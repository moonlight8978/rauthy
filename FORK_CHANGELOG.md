## [0.3.0](https://github.com/moonlight8978/rauthy/compare/v0.2.6...v0.3.0) (2026-03-30)

### Features

* **idp_hint:** Adds support to pass idp_hint as a parameter ([#1460](https://github.com/moonlight8978/rauthy/issues/1460)) ([21e1470](https://github.com/moonlight8978/rauthy/commit/21e1470eb1770b1251a87a64bd4d247f374d5c19))

## [0.2.6](https://github.com/moonlight8978/rauthy/compare/v0.2.5...v0.2.6) (2026-03-16)

# Changelog

## [0.2.4](https://github.com/moonlight8978/rauthy/compare/v0.2.3...v0.2.4) (2026-03-13)


### Build

* add trivy image scanning ([#51](https://github.com/moonlight8978/rauthy/issues/51)) ([f37d053](https://github.com/moonlight8978/rauthy/commit/f37d053712d3dc8cd4c2edfc3850b6c6a61d8f0f))
* add trivy scanning to publish workflow ([4c6f28a](https://github.com/moonlight8978/rauthy/commit/4c6f28a4933a4c9a6fbf96843f237a12f786707a))
* **deps-dev:** Bump devalue from 5.6.3 to 5.6.4 in /frontend ([#1458](https://github.com/moonlight8978/rauthy/issues/1458)) ([2367c3b](https://github.com/moonlight8978/rauthy/commit/2367c3b31053f5e7bd8099272581358ac0cbc164))
* **deps:** Bump actix-web-lab from 0.24.3 to 0.26.0 ([#1457](https://github.com/moonlight8978/rauthy/issues/1457)) ([fb66992](https://github.com/moonlight8978/rauthy/commit/fb6699237ca0c3ed366645a381f988c95ab88a8a))
* **deps:** Bump quinn-proto from 0.11.13 to 0.11.14 ([#1459](https://github.com/moonlight8978/rauthy/issues/1459)) ([5ac4f6a](https://github.com/moonlight8978/rauthy/commit/5ac4f6a209a29434a11ce50e96355cd02b677a7e))
* **deps:** Bump quinn-proto in /rauthy-client/examples/actix-web ([#1456](https://github.com/moonlight8978/rauthy/issues/1456)) ([013abf9](https://github.com/moonlight8978/rauthy/commit/013abf96b531971e8800f4dd0510271f874ac687))
* **deps:** Bump quinn-proto in /rauthy-client/examples/axum ([#1455](https://github.com/moonlight8978/rauthy/issues/1455)) ([5043530](https://github.com/moonlight8978/rauthy/commit/50435309113c269f89121915691ca7a05a4a752c))
* **deps:** Bump quinn-proto in /rauthy-client/examples/generic ([#1454](https://github.com/moonlight8978/rauthy/issues/1454)) ([f4f021a](https://github.com/moonlight8978/rauthy/commit/f4f021a17938029fb455f60fc2e75f5b63e2089a))

## [0.2.3](https://github.com/moonlight8978/rauthy/compare/v0.2.2...v0.2.3) (2026-03-09)


### Bug Fixes

* remove duplicated slash on issuer endpoints ([#49](https://github.com/moonlight8978/rauthy/issues/49)) ([9b62f03](https://github.com/moonlight8978/rauthy/commit/9b62f03f2dfbb1180d5f714b5c632d4910c53a16))


### Misc

* **deps:** docker/build-push-action action v6 → v7 ([#48](https://github.com/moonlight8978/rauthy/issues/48)) ([b0263f5](https://github.com/moonlight8978/rauthy/commit/b0263f58ab55d3770973d896252f2e459d8f3e6b))
* **deps:** docker/metadata-action action v5 → v6 ([#47](https://github.com/moonlight8978/rauthy/issues/47)) ([7d1ffe2](https://github.com/moonlight8978/rauthy/commit/7d1ffe265f11d54f630ac98b63f79ef807a752ce))
* **deps:** docker/setup-buildx-action action v3 → v4 ([#46](https://github.com/moonlight8978/rauthy/issues/46)) ([d3fff5a](https://github.com/moonlight8978/rauthy/commit/d3fff5a442e40b69ef486bb0b97a09d5542c2642))

## [0.2.2](https://github.com/moonlight8978/rauthy/compare/v0.2.1...v0.2.2) (2026-03-05)


### Misc

* **deps:** actions/checkout action v4 → v6 ([#41](https://github.com/moonlight8978/rauthy/issues/41)) ([ca354dc](https://github.com/moonlight8978/rauthy/commit/ca354dc13ca943a586a5f5fb6d681cd488df2b77))
* **deps:** docker/login-action action v3.6.0 → v4.0.0 ([#38](https://github.com/moonlight8978/rauthy/issues/38)) ([9d4219f](https://github.com/moonlight8978/rauthy/commit/9d4219fcd8bfebc81b5b873d9a9bae93a7ce9252))
* **deps:** docker/setup-qemu-action action v3 → v4 ([#39](https://github.com/moonlight8978/rauthy/issues/39)) ([87c1547](https://github.com/moonlight8978/rauthy/commit/87c1547422f1576b6373507e7b752c58df6eaf3f))
* **deps:** Node.js v22.22.0 → v24.14.0 ([#42](https://github.com/moonlight8978/rauthy/issues/42)) ([8b28166](https://github.com/moonlight8978/rauthy/commit/8b281663a71ea6d7b48382cebcaa278b98c9caab))
* disable cargo, npm renovate, prefer origin ([227a547](https://github.com/moonlight8978/rauthy/commit/227a547d74507d7511bf5bb56e129081e71ecf25))
* fix broken semver ([21ab785](https://github.com/moonlight8978/rauthy/commit/21ab785c17a34630dcb8311cf2f9b3cf5d133636))


### Build

* **deps-dev:** Bump minimatch from 10.2.2 to 10.2.4 in /frontend ([#1441](https://github.com/moonlight8978/rauthy/issues/1441)) ([c4439e6](https://github.com/moonlight8978/rauthy/commit/c4439e61936e7a83b1e15fc72144459f19dc280f))
* **deps-dev:** Bump rollup from 4.58.0 to 4.59.0 in /frontend ([#1442](https://github.com/moonlight8978/rauthy/issues/1442)) ([8d49882](https://github.com/moonlight8978/rauthy/commit/8d49882d5d39669e7f6f580de1c83ae3b4143db4))
* **deps-dev:** Bump svelte from 5.53.0 to 5.53.6 in /frontend ([#1440](https://github.com/moonlight8978/rauthy/issues/1440)) ([c3a2493](https://github.com/moonlight8978/rauthy/commit/c3a2493345db8b3f34a3866990fccdf6eb797e3c))

## [0.2.0](https://github.com/moonlight8978/rauthy/compare/v0.1.1...v0.2.0) (2026-02-25)


### Features

* unlink auth provider individually ([a82c43d](https://github.com/moonlight8978/rauthy/commit/a82c43d0257baaa08b6831e78cf59f557b58cbf9))


### Bug Fixes

* add unique constraint to user federation upstream id ([137b3cc](https://github.com/moonlight8978/rauthy/commit/137b3cc68d2177c47268ab1d919880d77fbd1c71))
* safe delete federation exist check query ([67a7547](https://github.com/moonlight8978/rauthy/commit/67a75470288d8aafbad4169c5560bc314b16e66d))
* show multiple federations in UI ([12f5a56](https://github.com/moonlight8978/rauthy/commit/12f5a560235c7309fa4fb35de2e3167c5b30d9af))
* unlink user federations when unlink ([b7e9859](https://github.com/moonlight8978/rauthy/commit/b7e9859a872190637e465b5e2236ec757a19cb66))
* user cache poisioning ([b8acd1d](https://github.com/moonlight8978/rauthy/commit/b8acd1dbbe9e96149e08c7316f0a41480859028c))


### Misc

* add release please config ([7dd72bf](https://github.com/moonlight8978/rauthy/commit/7dd72bf98dfed65ce21c5913c9b7905fcc648697))
* add renovate config ([8110989](https://github.com/moonlight8978/rauthy/commit/8110989185408f7df62a4c785e6b52091bbb8ad2))
* checkout original code for minimal changes ([f26e4b1](https://github.com/moonlight8978/rauthy/commit/f26e4b1c00d296a41072b3cd7278a2ed478de73d))
* **deps:** migrate Renovate config ([#8](https://github.com/moonlight8978/rauthy/issues/8)) ([2d254f5](https://github.com/moonlight8978/rauthy/commit/2d254f57be451e056c90e6d662327b071304a196))
* fix grammar, add issue link ([74cfd86](https://github.com/moonlight8978/rauthy/commit/74cfd8680297bc08e244c07d6f3335d64bb99274))


### Refactor

* cleanup legacy user federation logic ([2b99de5](https://github.com/moonlight8978/rauthy/commit/2b99de564d247039f99f8fc69d74cccedb4b7ddb))
