(function ($) {
  function onPageLoad(fn) {
    document.addEventListener("turbo:load", fn)
  }

  $.fn.ready = function (fn) {
    if (this.context === undefined) {
      onPageLoad(fn)
    } else if (this.selector) {
      onPageLoad(
        $.proxy(function () {
          $(this.selector, this.context).each(fn)
        }, this)
      )
    } else {
      onPageLoad(
        $.proxy(function () {
          $(this).each(fn)
        }, this)
      )
    }
  }
})(jQuery)
