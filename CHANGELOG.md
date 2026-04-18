# Changelog

## [2.1.0](https://github.com/lilz3bra/clackity/compare/v2.0.0...v2.1.0) (2026-04-18)


### Features

* added runtime type guard for run_load_hooks ([6398508](https://github.com/lilz3bra/clackity/commit/6398508199fa34370fa66a01647b0f2d0f88e103))


### Bug Fixes

* added close function and safety guard to save_lesson ([8bbe99f](https://github.com/lilz3bra/clackity/commit/8bbe99f64576b68b01c81002dbbca10d5e70c011))
* added safety check for invalid values in the on_load hook ([5778fe1](https://github.com/lilz3bra/clackity/commit/5778fe1a32989c8c22f2d7692cdd08f91ffe14b1))
* added safety checks for absolute path. correctly insert end-of-line space ([540deac](https://github.com/lilz3bra/clackity/commit/540deac0a29163a07641fcf630901683d7952b8d))

## [2.0.0](https://github.com/lilz3bra/clackity/compare/v1.1.0...v2.0.0) (2026-02-24)


### ⚠ BREAKING CHANGES

* implement EAV schema for session rules. Updated 'save_lesson' to accept active_rules as param

### Features

* added accent replace rule ([b96634a](https://github.com/lilz3bra/clackity/commit/b96634a4a82cf033f28d86241da4760db594e470))
* added db_ignore field, set hooks and order as optional fields ([018df3d](https://github.com/lilz3bra/clackity/commit/018df3daeb9653d828024e49c26a91ad23d09901))
* implement EAV schema for session rules. Updated 'save_lesson' to accept active_rules as param ([39ab7e3](https://github.com/lilz3bra/clackity/commit/39ab7e3d16942c79ecbc8e2e923c15f12bc253ce))
* implemented dynamic rules and hooks pipeline ([57a16e5](https://github.com/lilz3bra/clackity/commit/57a16e5fed838fb53b2a819d3798c11cfb8b020a))
* implemented new options menu logic using the new rules structure ([109e096](https://github.com/lilz3bra/clackity/commit/109e096aa92eafe7c29185910f10709c570e30ed))
* implemented old wordlist functions as rule hooks ([0f5dbc1](https://github.com/lilz3bra/clackity/commit/0f5dbc1f76a30164cf80b97daba13a519ec9efaf))


### Bug Fixes

* added a check in Start() to build the config if it doesnt exist ([db0fc29](https://github.com/lilz3bra/clackity/commit/db0fc29bd7b7892e231bceb9136af8e1c351f1b2))
* save the correct data to json config ([b98c0ae](https://github.com/lilz3bra/clackity/commit/b98c0ae85afa329fa31cb9e52c4a7b15be669f68))
* wordlist should now load correctly when launching nvim from a different dir. removed refactored function ([d355bf0](https://github.com/lilz3bra/clackity/commit/d355bf0cbd5a4de3d52e90b9be99a408d395ad9a))

## [1.1.0](https://github.com/lilz3bra/clackity/compare/v1.0.0...v1.1.0) (2026-02-22)


### Features

* added bindings for the selection menus ([0624639](https://github.com/lilz3bra/clackity/commit/062463987ae149568ebce38a8c99575a75053fb1))
* added selection highlight ([7f464f8](https://github.com/lilz3bra/clackity/commit/7f464f81d466035fac454172e2cc97bc59b59264))
* added selection windows ([bb12416](https://github.com/lilz3bra/clackity/commit/bb1241673afd6f63070f3eb0a797d9717727ca67))
* implemented wordlist config menu and wordlist selection menu ([95b2f3a](https://github.com/lilz3bra/clackity/commit/95b2f3ad2ed4f496e317479fe4a1eacdc0c022e2))


### Bug Fixes

* re-wired the lesson start to the new wordlist loader ([b1e518d](https://github.com/lilz3bra/clackity/commit/b1e518d4c3a02fb606fc0688fe8a97050450c218))
* resolve multibyte and dead-key input not working properly ([#4](https://github.com/lilz3bra/clackity/issues/4)) ([f1e76d0](https://github.com/lilz3bra/clackity/commit/f1e76d0c0427287d4200ac0ae83da24e5f1df727))

## 1.0.0 (2026-02-19)


### ⚠ BREAKING CHANGES

* implemented the historical db tables

### Features

* add versioning and testing actions ([5caec59](https://github.com/lilz3bra/clackity/commit/5caec59b32d758803fd9e3f651b9694eac061722))
* added health check ([744f762](https://github.com/lilz3bra/clackity/commit/744f762a0f92c01e8f62dadc65536a60458d9dcd))
* added key press detection ([4426d1c](https://github.com/lilz3bra/clackity/commit/4426d1cf353d0a2d7a980ebac2dfe4d74881912a))
* added placeholder for stats ([09bd1e7](https://github.com/lilz3bra/clackity/commit/09bd1e756d02b4763a5efba7066817b57df257d3))
* added readme ([7f001e5](https://github.com/lilz3bra/clackity/commit/7f001e5a1b9a029e06b28dea21393301f075187a))
* added some config. start implementing stats ([69e4dfe](https://github.com/lilz3bra/clackity/commit/69e4dfecabba506b991eca452c449afd7094422a))
* added some more words ([83f139f](https://github.com/lilz3bra/clackity/commit/83f139f33f9349c75a245e94399a41a29fe92291))
* added sqlite dependency to readme ([3ffc931](https://github.com/lilz3bra/clackity/commit/3ffc931557ed84c8b375cb37e6e734461521b47c))
* added sqlite.lua check ([5af6275](https://github.com/lilz3bra/clackity/commit/5af627538f7ed90a4633b4562e54fec14c7f7e4e))
* added tests and testing env ([fc26fbc](https://github.com/lilz3bra/clackity/commit/fc26fbc284af863c257ba3d7a3a0086f84a9e6f6))
* deleted file to rewrite a better architecture ([4a71c1b](https://github.com/lilz3bra/clackity/commit/4a71c1b65ab3453c54064c4f5e5156d28b00ba8c))
* finished the db implementation for the lesson and key data ([b5f03de](https://github.com/lilz3bra/clackity/commit/b5f03de190b2728c17c61f2cf4ff2ee488e3d0c6))
* fixed the typing for existing classes. removed leftover debug logs ([02c980d](https://github.com/lilz3bra/clackity/commit/02c980d203b3e47c4b29be90c428c426e2a261f3))
* implemented basic main window (buggy) ([e6ed47c](https://github.com/lilz3bra/clackity/commit/e6ed47c3bea3f5774deb5b12bc9ce9870ecd6fc2))
* implemented basic sqlite client ([bbaeb02](https://github.com/lilz3bra/clackity/commit/bbaeb029b9cdf06ba48a9da9b48c1401eb1344f2))
* implemented basic wordlist loading ([073ca5c](https://github.com/lilz3bra/clackity/commit/073ca5c59c333d13cb957766c493310d944a8382))
* implemented consistency calculation ([f29214b](https://github.com/lilz3bra/clackity/commit/f29214b4dd1cf530f7b8769707f1a848d325260f))
* implemented db initialization and basic session saving ([ffc1303](https://github.com/lilz3bra/clackity/commit/ffc1303ecb1223152746cff923897cd0593ebd43))
* implemented highlighting to color the words ([d512a7e](https://github.com/lilz3bra/clackity/commit/d512a7e82792e4376320a9839ad70088b09895e0))
* implemented post lesson summary stats ([d926198](https://github.com/lilz3bra/clackity/commit/d9261980cdf7c3931afc70e1637be43d01f7f972))
* implemented the historical db tables ([88b7a1c](https://github.com/lilz3bra/clackity/commit/88b7a1cb93d2f23b5050b5a0bc37badd007bfec4))
* improve the typing for state. added typing for the db ([8ecaf30](https://github.com/lilz3bra/clackity/commit/8ecaf308ec5d8d6ba1a0ba0018c5d1f0689e2bc2))
* load words instead of hardcoding. change window border ([d1945f2](https://github.com/lilz3bra/clackity/commit/d1945f20b2c7132a19a991066ac369d5f0a77e92))
* major de-spagghetification ([2a7930c](https://github.com/lilz3bra/clackity/commit/2a7930c21935d57485b2c93f5dafe4a475fc9cd9))
* now check the key pressed ([a5cfdd5](https://github.com/lilz3bra/clackity/commit/a5cfdd58621d4bf57d4c4952f73ec9fe15ffa4fd))
* refactor to increase readability. fix vim.o.timeoutlen issue in window.lua ([492f1d0](https://github.com/lilz3bra/clackity/commit/492f1d09481cb3075a57fb16f9b0f684abd848b9))
* restructured project. refactor to separate ui logic. implement .luarc to stop lsp from complaning ([cfef553](https://github.com/lilz3bra/clackity/commit/cfef553c14ba9dfc49bd5c773e9fa0cd30004f40))
* start adding type definitions ([46968bb](https://github.com/lilz3bra/clackity/commit/46968bb9850f9eb5a0fab7e0d411836460283a93))
* starting stats implementation ([daaba97](https://github.com/lilz3bra/clackity/commit/daaba974d06933e77607a0ed5e6233e4bebe1a2d))
* updated readme ([e388a4b](https://github.com/lilz3bra/clackity/commit/e388a4bc5b5e5d3e699ef5e0dba2d00226176075))
* updated requirements ([857d9a0](https://github.com/lilz3bra/clackity/commit/857d9a0c5b34bc4d9eff68f438e540170c461db9))
* updated roadmap and other minor changes ([e9a0f68](https://github.com/lilz3bra/clackity/commit/e9a0f683a707d323e5fdd2eee09364b74151711d))
* words are now in lines ([edba226](https://github.com/lilz3bra/clackity/commit/edba226897188092dae92b8ab1b574da76b9aa98))


### Bug Fixes

* changed the quit keybinding to be local to the buffer ([5da851d](https://github.com/lilz3bra/clackity/commit/5da851d5c8fb61d4072074e21b128e4bbf7cf1f2))
* finally fixed the bad highlighting ([edfd483](https://github.com/lilz3bra/clackity/commit/edfd483d28923902da7998a48ed71d60a2d49cd4))
* Moved editorconfig to its correct location ([aff84f8](https://github.com/lilz3bra/clackity/commit/aff84f8e62abd77d44fe8b90d95813760192c61d))
* now the end of the line includes a space ([e35fb0c](https://github.com/lilz3bra/clackity/commit/e35fb0c340501ca92d884fe046b0da482b74dd34))
* now the time is returned as integers (ms) to avoid cummulative floating point errors ([cb7470b](https://github.com/lilz3bra/clackity/commit/cb7470bca4f45c7e7c8e54c72d0628081fc03d97))
* redoing a lesson now remaps the keys ([94d6a83](https://github.com/lilz3bra/clackity/commit/94d6a83797c53e961c9614a797ff3cea3b67eb64))
* some bindings were missing &lt;&gt; ([ee36808](https://github.com/lilz3bra/clackity/commit/ee368085138cd0cc4dfe15d746469d3393e53879))
* workflows target master ([f0f7a20](https://github.com/lilz3bra/clackity/commit/f0f7a20ea45e5091d7adf3dba021b7d7ae2eb659))
