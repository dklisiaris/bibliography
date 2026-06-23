/*
 *  Document   : app.js
 *  Author     : pixelcave
 *  Description: Custom scripts and plugin initializations (available to all pages)
 *
 *  Feel free to remove the plugin initilizations from uiInit() if you would like to
 *  use them only in specific pages. Also, if you remove a js plugin you won't use, make
 *  sure to remove its initialization from uiInit().
 */

var App = function() {

    /* Helper variables - set in uiInit() */
    var page, pageContent, header, sidebar, sBrand, sExtraInfo, sidebarAlt, sScroll, sScrollAlt;

    /* Initialization UI Code */
    var uiInit = function() {
        header          = $('.app-shell__navbar');
        pageContent     = $('#page-content');
        sidebar         = $('#sidebar');

        if (header.length) {
            $(window).on('scroll', function(){
                if ($(this).scrollTop() > 50) {
                    header.addClass('navbar-glass');
                } else {
                    header.removeClass('navbar-glass');
                }
            });
        }

        $(window).on('resize orientationchange', function(){ resizePageContent(); }).resize();

        $('.pie-chart').easyPieChart({
            barColor: $(this).data('bar-color') ? $(this).data('bar-color') : '#777777',
            trackColor: $(this).data('track-color') ? $(this).data('track-color') : '#eeeeee',
            lineWidth: $(this).data('line-width') ? $(this).data('line-width') : 3,
            size: $(this).data('size') ? $(this).data('size') : '80',
            animate: 800,
            scaleColor: false
        });

        var $bookCoverImg = $('.book-box .book-cover img');
        if ($bookCoverImg.length) {
            $bookCoverImg.height($bookCoverImg.width() * 1.5);
        }
    };

    /* Legacy ProUI sidebar — retired (B.4 app-shell + Stimulus). */
    var handleSidebar = function() {};

    /* Resize #page-content to fill empty space if exists */
    var resizePageContent = function() {
        if (!pageContent.length) return;

        var windowH = $(window).height();
        var headerH = header.length ? header.outerHeight() : 0;
        pageContent.css('min-height', windowH - headerH);

        var $bookCoverImg = $('.book-box .book-cover img');
        if ($bookCoverImg.length) {
            $bookCoverImg.height($bookCoverImg.width() * 1.5);
        }
    };

    var handlePrint = function() {
        var shell = $('.app-shell');
        var pageCls = shell.prop('class');
        shell.prop('class', 'app-shell');

        window.print();

        shell.prop('class', pageCls);
    };

    return {
        init: function() {
            uiInit(); // Initialize UI
        },
        sidebar: function(mode, extra) {
            handleSidebar(mode, extra); // Handle sidebars - access functionality from everywhere
        },
        pagePrint: function() {
            handlePrint(); // Print functionality
        }
    };
}();

