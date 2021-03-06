// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.cssemoticons
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require moment
//= require bootstrap
//= require messenger
//= require messenger-theme-future
//= require pusher.min
//= require jquery.lazyload.min
//= require_tree .

function strfy(obj){
  var str = "";
  for (const [key, value] of Object.entries(obj)) {
    str +=  ` ${key.split("_").join(" ")}: ${value}. `;
  }
  return str
}
