# Changelog

All notable changes to this project will be documented in this file.

## [2.2.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v2.1.1...v2.2.0) (2024-04-05)


### Features

* Added repository_name as output ([#37](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/37)) ([d704c6e](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/d704c6e6b88726a9f24c466d38654ab9470de181))

## [2.1.1](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v2.1.0...v2.1.1) (2024-04-03)


### Bug Fixes

* Correct typo `credentials_arn` -> `credential_arn` ([#36](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/36)) ([b5bd6a4](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/b5bd6a4cadf0e9f66ea144ba16f6e7455c778416))

## [2.1.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v2.0.0...v2.1.0) (2024-03-25)


### Features

* Add `credentials_arn` to support ECR pull through cache ([#30](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/30)) ([05e6fd0](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/05e6fd073519aa61e880e6a3b4712d67087ea77f))

## [2.0.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.7.1...v2.0.0) (2024-03-15)


### ⚠ BREAKING CHANGES

* Allow multiple scan filters per scan type in registry; Raise MSV of Terraform and AWS provider to 1.0 and 5.0 respectively (#29)

### Features

* Allow multiple scan filters per scan type in registry; Raise MSV of Terraform and AWS provider to 1.0 and 5.0 respectively ([#29](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/29)) ([cbba4fd](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/cbba4fd31f5a7a04b3d57666c409996bf5eb2bdd))

## [1.7.1](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.7.0...v1.7.1) (2024-03-07)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#28](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/28)) ([1f74cc5](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/1f74cc5b0b5982bb4be0faed117faba1d3b92773))

## [1.7.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.6.0...v1.7.0) (2024-03-04)


### Features

* Add support for creating custom repository policy statements ([#27](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/27)) ([fb9126c](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/fb9126ca4c9a5c2d3213f525e040d4a84ff6e71c))

## [1.6.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.5.1...v1.6.0) (2023-02-16)


### Features

* Add new variable for allowing ECR image sharing to lambda service in external account ([#16](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/16)) ([be2edd1](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/be2edd1b481e14e45d5d548ca47e04c41dce2058))

### [1.5.1](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.5.0...v1.5.1) (2022-11-12)


### Bug Fixes

* Update CI configuration files to use latest version ([#13](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/13)) ([885f800](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/885f800769f2616aa8306190aa664f6f88633404))

## [1.5.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.4.0...v1.5.0) (2022-10-31)


### Features

* Added ecr:GetAuthorizationToken for private ECR with Docker capabilities ([#12](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/12)) ([0a087ca](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/0a087ca8c2d9097fe2b73e112549739962114c9f))

## [1.4.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.3.2...v1.4.0) (2022-07-14)


### Features

* Add support for `force_delete` attribute ([#9](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/9)) ([850ddb0](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/850ddb0a35188785b3dee3e64ad8833175f7376e))

### [1.3.2](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.3.1...v1.3.2) (2022-06-26)


### Bug Fixes

* Add new variable to control whether a repository policy is attached to the repository ([#8](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/8)) ([4706acf](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/4706acfd9137a1bd2ccf918767c48ec73b99dfbd))

### [1.3.1](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.3.0...v1.3.1) (2022-06-26)


### Bug Fixes

* Update the permission for the public ecr ([#7](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/7)) ([70f3252](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/70f3252311f29bc9dc3ea6e72ec2abb70c387eb1))

## [1.3.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.2.0...v1.3.0) (2022-06-13)


### Features

* Add a new variable to control the creation of a lifecycle policy ([#4](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/4)) ([18c0515](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/18c05151fa481a02a93ba2ab549842b0e5bddf1a))

## [1.2.0](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.1.1...v1.2.0) (2022-06-07)


### Features

* Add wrapper module and pre-commit hook ([#3](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/3)) ([c2284be](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/c2284be33c572839d178bcbcf53f1eaaebe5016c))

### [1.1.1](https://github.com/terraform-aws-modules/terraform-aws-ecr/compare/v1.1.0...v1.1.1) (2022-04-21)


### Bug Fixes

* Update documentation to remove prior notice and deprecated workflow ([#1](https://github.com/terraform-aws-modules/terraform-aws-ecr/issues/1)) ([4de4770](https://github.com/terraform-aws-modules/terraform-aws-ecr/commit/4de4770117a8574b28f9ebe99b8823137e3e2ff0))

## [1.1.0](https://github.com/clowdhaus/terraform-aws-ecr/compare/v1.0.0...v1.1.0) (2022-04-20)


### Features

* Repo has moved to [terraform-aws-modules](https://github.com/terraform-aws-modules/terraform-aws-ecr) organization ([8e15f9a](https://github.com/clowdhaus/terraform-aws-ecr/commit/8e15f9aa955e5f7ce7832bf9514ac149c0f8d631))
