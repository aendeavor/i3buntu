# ![FireFox Quantum Material Logo](./logo.png)

## Customizing Firefox (Quantum)

### Theming

#### Firefox Colors

Add the [Firefox Color extension](https://addons.mozilla.org/en-US/firefox/addon/firefox-color/?src=search) to your browser and click [here](https://color.firefox.com/?theme=XQAAAAIfAQAAAAAAAABBqYhm849SCia2CaaEGccwS-xNKlhWuMf61H-qemtFQ7JmIThKEJYbO6BYtxXFN3QVwfgIyLdrYygaud86UIpkiO8YN31rNYQT4wbIyYwCNHU7jaUMww6R7XMYKHXDUCvMW7_0AiLugqKwZ2mhpvOqQw__PRrGb_w5dNZqMUkPfE4UsOjehwu76ZgYlAyi-kcs2o76aC30rqSaUf9RJtUHhA_oQODqn_yh5tM) to apply the colors.

#### CSS

A derivative of [_Material Fox_](https://github.com/muckSponge/MaterialFox) patched with [_Flying Fox_](https://github.com/akshat46/FlyingFox), changed to own preferences and to work without _Tree Style Tab_.

The `chrome` folder can just be unpacked with `tar xf` and then copied to your Firefox profile directory. You can get there by searching for `about:support` in the searchbar.

#### Policies

Set all the following policies to true. You can do this under `about:config`.

`toolkit.legacyUserProfileCustomizations.stylesheets`
`svg.context-properties.content.enabled`

### Extensions

#### Humble New Tab Page (HNTP)

Copy [`custom.css`](./hntp/custom.css) into the field called Custom CSS under the Advanced tab when in HNTP settings. Moreover, copy [`import.css`](./hntp/import.css) into the field Import Settings under Import/Export. Then, disable Mobile Bookmarks, Recently Closed and Recent Bookmarks to your taste under the Settings tab. Thereafter, set the default starting page to HNTP in Firefox's settings. Open a new tab and select current page in the settings.
