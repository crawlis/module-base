##################################################
#                                                #
# THIS IMAGE SHOULD BE USED TO:                  #
#   - Run the microservice you are developping   #
#   - Run it in debug mode                       #
#                                                #
##################################################

# This is a development dockerfile optimized to :
#   - Reduce the build time: non-project binaries are cached
#   - Reduce the image space: the project is installed as a binary runnable from scratch image

##################################################
#                                                #
# BUILDER                                        #
#                                                #
# Debian-based image for openssl compillation    #
#                                                #
##################################################
FROM ekidd/rust-musl-builder as builder

RUN rustup self update
RUN rustup target add x86_64-unknown-linux-musl

# Create a new empty shell project to cache dependencies
RUN USER=root cargo new --bin --vcs none keeper
WORKDIR /home/rust/src/keeper
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
RUN cargo build --target x86_64-unknown-linux-musl
RUN rm src/*.rs && \
    rm -rf ./target/x86_64-unknown-linux-musl/debug/deps/keeper*

# Install the binary
COPY ./src ./src
RUN cargo build --target x86_64-unknown-linux-musl
RUN chmod +x ./target/x86_64-unknown-linux-musl/debug/keeper

##################################################
#                                                #
# SCRATCH                                        #
#                                                #
# Empty image to execute binary                  #
#                                                #
##################################################
FROM scratch

# Adding the binary
COPY --from=builder /home/rust/src/keeper/target/x86_64-unknown-linux-musl/debug/keeper .

# Adding SSL certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR=/etc/ssl/certs
CMD ["./keeper"]