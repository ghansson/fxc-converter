# fxc-converter
Command line currency converter

Requires system dependencies LibXML and zlib.

## Installation

```(bash)
git clone git@github.com:ghansson/fxc-converter && cd fxc-converter
cpan Module::Build
perl Build.PL
./Build installdeps
./Build install
```
## Usage

```fx [amount] [from currency] in [to currency]```

Example

```(bash)
fx 10 SEK in BRL # - or -
fx 10 SEK BRL # - or -
```
Rates are cached daily in ```$HOME/.fx-converter-cache.xml```

