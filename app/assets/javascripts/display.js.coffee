class window.Display 
  @getViewport = ->
    viewPortWidth = undefined
    viewPortHeight = undefined
    # the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
    if typeof window.innerWidth != 'undefined'
      viewPortWidth = window.innerWidth
      viewPortHeight = window.innerHeight
    else if typeof document.documentElement != 'undefined' and typeof document.documentElement.clientWidth != 'undefined' and document.documentElement.clientWidth != 0
      viewPortWidth = document.documentElement.clientWidth
      viewPortHeight = document.documentElement.clientHeight
    else
      viewPortWidth = document.getElementsByTagName('body')[0].clientWidth
      viewPortHeight = document.getElementsByTagName('body')[0].clientHeight
    [
      viewPortWidth
      viewPortHeight
    ]

  @initDisplay = ->
    display = this.getViewport()
    width = display[0]
    height = display[1]
    if width > 768
      hHeight = height - $('#header').outerHeight() - $('.sub-menu').outerHeight()
      $('.center-main-content').css 'height', hHeight
      $('.left-main-content').css 'height', hHeight
      $('body').css 'overflow-y', 'hidden'
    hHeight


