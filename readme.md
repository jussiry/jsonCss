
Build CSS with JSON and use the full power of JavaScript instead of reinventing wheel with precompilers.

Play with example code in here: http://jussir.net/#/edit/jsonCssExample
```coffee
blackBox =
  padding: 10
  background: 'black'
  color: 'white'

cssDefinitions =
  '.jsonCssExample':
    # camelCase poperty names transform to kebab-case, e.g.
    # borderRadius -> border-radius
    borderRadius: "10px"
    # pixel values can be defined with plain numbers:
    padding: 10
    background: 'white'
    color: 'black'
    h1:
      fontSize: 14
      # & -sign can be used to mixin definition to parent
      '&': blackBox
      # unlike with jsonHtml, whitespace characters do matter
      '&.second':
        color: "hsl(120, 90%, 45%)"
    ul:
      padding: blackBox.padding
      li:
        # add -v to property to create vendor prefixes
        "filter -v": "blur(2px)"
    '.remove':
      color: 'red'
      margin: 10
  # nested definitions can also be define in one string
  'body pre': blackBox

jsonCss.addStyles(styleId, cssDefinitions)
```
↓
```css
.jsonCssExample {
  border-radius: 10px;
  padding: 10px;global
  background: white;
  color: black;
}
.jsonCssExample h1 {
  font-size: 14px;
}
.jsonCssExample h1 {
  padding: 10px;
  background: black;
  color: white;
}
.jsonCssExample h1.second {
  color: hsl(120, 90%, 45%);
}
.jsonCssExample ul {
  padding: 10px;
}
.jsonCssExample ul li {
  -webkit-filter: blur(2px);
  -moz-filter: blur(2px);
  -ms-filter: blur(2px);
  filter: blur(2px);
}
.jsonCssExample .remove {
  color: red;
  margin: 10px;
}
body pre {
  padding: 10px;
  background: black;
  color: white;
}
```

## Install

Just import dist/jsonCss.min.js

Library uses CommonJS syntax for export, or window.jsonCss when local 'module' variable not defined.

With JSPM, it can be installed directly: jspm install github:jussiry/jsonCss


## jsonHtml

Combine with [jsonHtml](https://github.com/jussiry/jsonHtml) to create compact UI modules with HTML, JS, and controller all in same file. See an [example here](https://github.com/jussiry/jsonHtmlStyleExample).


## CCSS

This library is a fork from James Campos's [CCSS](https://github.com/aeosynth/ccss)
