# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#keeps current theater in browser goto selected theater
update_theater = () ->
  current_theater = location.hash
  if current_theater.length == 0
    current_theater = $('.theater_name > a').first().attr('href')
  if $.browser.webkit == false
    window.location.hash = current_theater
  else
    window.location.href = current_theater;
    window.location.href = current_theater


filtered = []

#refresh movies is set to 'or' like behavior
refresh_movies = () ->
  if filtered.length == 0
    for movie in $('.movies')
        $(movie).css("display", "block")
    return true
  for movie in $('.movies')
    $(movie).css("display", "none")
    for movie_box in $(movie).children('.movie_box')
      if $(movie_box).attr("name") in filtered
        $(movie).css("display", "block")
        break

filter_movie = (filtered_movie) ->
  filtered.push $.trim(filtered_movie)
  refresh_movies()
  update_theater()

unfilter_movie = (unfiltered_movie) ->
  filtered.splice(filtered.indexOf($.trim(unfiltered_movie)), 1)
  refresh_movies()
  update_theater()



slider_action = (event, ui) ->
  time = ui.value
  if time < 12
    $('#time_display').text( time + ':00 am' )
  else if time > 24
    $('#time_display').text( (time - 24) + ':00 am' )
  else if time == 24
    $('#time_display').text( (time - 12) + ':00 am' )
  else if time > 12 and time < 24
    $('#time_display').text( (time - 12) + ":00 pm" )
  else
    $('#time_display').text( time + ":00 pm" )


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
      clicked = $.trim($(this).children('.movie_title').first().html())
      unfilter_movie(clicked) #'unhide'?
    else
      $(this).css("background-color", "gold")
      $(this).children('.movie_title').css("color", "black");
      $(this).addClass("selected_movie")
      clicked = $.trim($(this).children('.movie_title').first().html())
      filter_movie(clicked) #reduce to only movie sets w/ that movie


#not exactly what I want
  $('.movies').hover(
    () -> $("#" + $(this).parent().attr('tid')).css("color", "gold")
    () -> $("#" + $(this).parent().attr('tid')).css("color", "white"))

  $('.movies').hover(
    () -> console.log($(this).offset())
  )