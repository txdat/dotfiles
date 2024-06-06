# about:config

- `browser.compactmode.show=true`
- `extensions.webextensions.restrictedDomains=[]` # erase all items
- `nglayout.initialpaint.delay=2000`
- `nglayout.initialpaint.delay_in_oopif=2000`
- `network.IDN_show_punycode=true`
- `toolkit.legacyUserProfileCustomizations.stylesheets=true`
- `extensions.pocket.enabled=false`

# scripts

- disable telemetry

```bash
curl https://raw.githubusercontent.com/FirefoxUniverse/FirefoxTweaksVN/main/user.js -o ~/.mozilla/firefox/*.default-release/user.js # profile directory in about:support
```

- custom UI

```bash
ln -s ~/.dotfiles/firefox/chrome ~/.mozilla/firefox/*.default-release/chrome # profile directory in about:support
```
