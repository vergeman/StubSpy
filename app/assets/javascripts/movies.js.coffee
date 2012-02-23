# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

filter_movie = (mid) ->
  alert(mid)



jQuery ->
  $('#mycarousel').jcarousel( {scroll: 5});

  $('#time_slider').slider();

  $('.slider_link').click (e) ->
    e.preventDefault()

  $('.jcarousel li').click () ->
    if $(this).css("background-color") == "rgb(255, 215, 0)"
      $(this).css("background-color", '#900')
      $(this).removeClass("selected_movie")
    else
      $(this).css("background-color", "gold")
      $(this).addClass("selected_movie")
      filter_movie($(this))