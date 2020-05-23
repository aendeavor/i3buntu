# Customizing Firefox (Quantum)

## CSS

This theme combines the files from [_Material Fox_](https://github.com/muckSponge/MaterialFox) with a "patched" version from [_Flying Fox_](https://github.com/akshat46/FlyingFox). A minor fix has been done to the `--menubar-height`, which has been set to `-opx`.

The `chrome` folder can just be copied to your Firefox profile directory. You can get there by just "searching" for `about:support` in the searchbar.

## Policies

Set all the following policies to true. You can do this under `about:config`.

`toolkit.legacyUserProfileCustomizations.stylesheets`,
`svg.context-properties.content.enabled`

## Extensions

All extensions should be installed automatically when logging in with your Firefox account. The configurations might not be synchronized.

### Tree Style Tab

1. Navigate to the extensions settings page
2. Scroll all the way down and select import; choose [`config.json`](./extensions/tst/config.json)
3. Select _Vertigo_ theme
4. Set "Style of contents for the sidebar position" to "Right Side"
5. Scroll all the way down to "All Configs", click on the small black triangle to expand the menu if it isn't already, uncheck the checkboxes `autoAttach` and `syncParentTabAndOpenerTab`
6. Paste contents of [`custom.css`](./extensions/tst/custom.css) to the text field under the "Advanced" section

### Humble New Tab Page (HNTP)

Copy [`custom.css`](./extensions/hntp/custom.css) into the filed called Custom CSS under the Advanced tab when in HNTP settings. Moreover, copy [`import.css`](./extensions/hntp/import.css) into the field Import Settings under Import/Export.
