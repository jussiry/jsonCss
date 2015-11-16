# jsonStyles is forked from James Campos's CCSS: https://github.com/aeosynth/ccss

# Export in module.exports, this, or global.jsonHtml
globalRef = window ? global
if (module? and module isnt globalRef.module)
  module.exports = jsonCss = {}
else if @ is globalRef
  @jsonCss = jsonCss = {}
else
  jsonCss = @


jsonCss.addStyles = (el_id, rules)->
  return console.error "Trying to create StyleSheet rules on server side!" unless window?
  if arguments.length is 1
    rules = el_id
    el_id = 'main'
  # add styles post fix, since often the same id is used as with the component it styles
  el_id = el_id + '_styles'
  rules = rules() if typeof rules is 'function' # then rules.call(jsonCss.helpers) else rules
  cssStr = if typeof rules is 'object' \
           then jsonCss.compile rules
           else rules
  styleEl = document.getElementById el_id
  unless styleEl?
    styleEl = document.createElement 'style'
    styleEl.id = el_id
    document.head.appendChild styleEl
  if el_id is 'main_styles'
    styleEl.innerHTML += cssStr
  else
    styleEl.innerHTML  = cssStr
  return

jsonCss.removeStyles = (el_id)->
  unless el_id
    throw Error "Missing id for for styles to be removed"
  document.head.removeChild document.getElementById(el_id + '_styles')

# PARSER

non_pixel_props = ['font-weight', 'opacity', 'z-index', 'zoom']

vendors = (property_name, val)->
  obj = {}
  for vendor in ['webkit', 'moz', 'ms']
    obj["-#{vendor}-#{property_name}"] = val
  obj[property_name] = val # standard
  obj

create_property_string = (key, value)->
  # borderRadius -> border-radius
  key = key.replace /[A-Z]/g, (s) -> '-' + s.toLowerCase()
  # 13 -> 13px
  if typeof value is 'number' and non_pixel_props.indexOf(key) is -1
    value = "#{value}px"
  # "borderRadius -v" -> all verdor versions
  if key.match(/ -v$/)
    key = key.slice(0, -3)
    (for key, val of vendors(key, val)
      "  #{key}: #{value};\n"
    ).join ''
  else
    "  #{key}: #{value};\n"

jsonCss.compile = (rulesObj) -> # , styleSheet
  jsonCss.stack ?= []
  if jsonCss.stack.indexOf(rulesObj) isnt -1 or jsonCss.stack.length is 100
    console.warn 'jsonCss.stack', jsonCss.stack
    throw "Endless stack in jsonCss.compile!"
  jsonCss.stack.push rulesObj

  cssStr = ''
  for selector, childRules of rulesObj
    declarations = ''
    nested = {}

    for key, value of childRules
      if typeof value is 'object'
        children = []
        for childSelector in key.split /\s*,\s*/
          for parentSelector in selector.split /\s*,\s*/
            combineStr = switch childSelector[0..0]
              when ':' then ''
              when '&'
                childSelector = childSelector[1..-1]
                ''
              else ' '
            children.push parentSelector + combineStr + childSelector
        nested[children.join ','] = value
      else
        declarations += create_property_string key, value

    if declarations.length
      newCSS = "#{selector} {\n#{declarations}}\n"
      cssStr += newCSS
    cssStr += jsonCss.compile nested #, styleSheet
  jsonCss.stack.pop()
  cssStr
