# Changelog

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
