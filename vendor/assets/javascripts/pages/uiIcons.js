/*
 *  Document   : uiIcons.js
 *  Author     : pixelcave
 */
var UiIcons=function(){return{init:function(){var t;$("#page-content .btn").click(function(){return t=$(this).attr("data-original-title"),$("#icon-gen-input").val('<i class="'+t+'"></i>').select(),$("html,body").animate({scrollTop:$("#icon-gen").offset().top-15}),!1})}}}();