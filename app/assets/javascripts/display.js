// init display
function getViewport() {
  var viewPortWidth;
  var viewPortHeight;
    // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
    if (typeof window.innerWidth != 'undefined') {
      viewPortWidth = window.innerWidth,
      viewPortHeight = window.innerHeight
    }

    // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)
    else if (typeof document.documentElement != 'undefined'
      && typeof document.documentElement.clientWidth !=
      'undefined' && document.documentElement.clientWidth != 0) {
      viewPortWidth = document.documentElement.clientWidth,
    viewPortHeight = document.documentElement.clientHeight
  }

    // older versions of IE
    else {
      viewPortWidth = document.getElementsByTagName('body')[0].clientWidth,
      viewPortHeight = document.getElementsByTagName('body')[0].clientHeight
    }
    return [viewPortWidth, viewPortHeight];
}

function initDisplay() {
  var display = getViewport();
  var width = display[0];
  var height = display[1];
  if(width > 768) {
    var hHeight = height - $("#header").outerHeight() - $('.sub-menu').outerHeight();
    $(".center-main-content").css("height", hHeight);
    $(".left-main-content").css("height", hHeight);
    $('body').css("overflow-y", "hidden");
  }
  return hHeight;
}
initDisplay();
