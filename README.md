# crawlis - module_base

[![Build Status](https://travis-ci.com/crawlis/module_base.svg?branch=master)](https://travis-ci.com/github/crawlis/module_base)

This is a generic repository to start a new Crawlis microservice.

## Getting started

You just have to create a fresh repository and use this one as a template.

Then you'll need to update the following files by replacing every occurences of `module_base` by your module name:

- `.travis.yml` x1
- `docker-compose.yml` x1
- `dockerfiles/local-module-debug.Dockerfile` x2
- `dockerfiles/local-module-release.Dockerfile` x2
- `src/Cargo.toml` x1
