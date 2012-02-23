# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
filtered = []

filter_movie = (mid) ->
  console.log (movie.name for movie in sequence.movie_times for sequence in theater.list for theater in results)


slider_action = () ->
  $('#time_display').val( $('#time_slider').slider("value"))

jQuery ->
  $('#mycarousel').jcarousel( {scroll: 5});

  $('#time_slider').slider( {
    range: "max",
    min: parseInt($('#time_slider').attr('start_time')),
    max: parseInt($('#time_slider').attr('end_time')),
    value: parseInt($('#time_slider').attr('start_time')),
    slide: slider_action
  });


  $('.slider_link').click (e) ->
    e.preventDefault()

  $('.jcarousel li').click () ->
    if $(this).css("background-color") == "rgb(255, 215, 0)"
      $(this).css("background-color", '#900')
      $(this).children('.movie_title').css("color", "white");
      $(this).removeClass("selected_movie")
    else
      $(this).css("background-color", "gold")
      $(this).children('.movie_title').css("color", "black");
      $(this).addClass("selected_movie")
      filter_movie($(this))

