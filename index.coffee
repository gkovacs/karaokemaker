root = exports ? this

time_to_gwordnum_count = []
root.time_to_gwordnum_count = time_to_gwordnum_count

global_wordnum_to_linenum = []
global_wordnum_to_wordnum = []
root.global_wordnum_to_linenum = global_wordnum_to_linenum
root.global_wordnum_to_wordnum = global_wordnum_to_wordnum

FRACSEC = 4

root.videoLoaded = ->
  videoWidth = $('video')[0].videoWidth
  $('video').css('left', '50%')
  $('video').css('margin-left', -Math.round(videoWidth/2))
  #$('#videoSpacing').css('margin-top', ($('video').offset().top + $('video')[0].videoHeight))
  duration = $('video')[0].duration*FRACSEC
  lyrics_by_line = root.lyrics.toUpperCase().split('\n')
  global_wordnum = 0
  for time in [0..Math.round(duration*FRACSEC)]
    time_to_gwordnum_count[time] = []
    for line,linenum in lyrics_by_line
      for word,wordnum in line.split(' ')
        time_to_gwordnum_count[time].push(0)
        #global_wordnum_to_linenum[global_wordnum] = linenum
        #global_wordnum_to_wordnum[global_wordnum] = wordnum
        global_wordnum += 1
  return ''

hovered_global_wordnum = -1

root.wordhover = (global_wordnum) ->
  hovered_global_wordnum = global_wordnum
  #$('.wordspanHovered').css('font-weight', 'normal')
  #$('.wordspanHovered').removeClass('wordspanHovered')
  #$(".ws#{linenum}_#{wordnum}").css('font-weight', 'bold')
  #$(".ws#{linenum}_#{wordnum}").addClass('wordspanHovered')

root.wordout = (global_wordnum) ->
  if global_wordnum == hovered_global_wordnum
    hovered_global_wordnum = - 1
  #$(".ws#{linenum}_#{wordnum}").css('font-weight', 'normal')
  #$(".ws#{linenum}_#{wordnum}").removeClass('wordspanHovered')

$(document).ready( ->
  lyricsDisp = []
  for i in [0..25]
    lyricsDisp.push '<br/>'
  global_wordnum = 0
  for line,linenum in root.lyrics.toUpperCase().split('\n')
    for word,wordnum in line.split(' ')
      lyricsDisp.push "<span class='wordspan ws#{linenum}_#{wordnum} wsg#{global_wordnum}' linenum=#{linenum} wordnum=#{wordnum} global_wordnum=#{global_wordnum} onmouseover='wordhover(#{global_wordnum})' onmouseout='wordout(#{global_wordnum})'> #{word} </span>"
      global_wordnum += 1
    lyricsDisp.push '<br/><br/>'
  $('#lyricsDisplay').html(lyricsDisp.join(''))
  $('#lyricsDisplay').show()
  return ''
)

prevX = -1

makeWordBold = (gwordnum) ->
  if $('.bolded').attr('global_wordnum') == gwordnum.toString()
    console.log 'already bolded'
    return
  $('.bolded').css('font-weight', 'normal')
  $('.bolded').removeClass('bolded')
  $(".wsg#{gwordnum}").css('font-weight', 'bold')
  $(".wsg#{gwordnum}").addClass('bolded')

$(document).mousemove( (e) ->
  newX = e.offsetX
  if $('video')[0].paused
    return
  if hovered_global_wordnum != -1 and newX > prevX
    time = Math.round($('video')[0].currentTime * FRACSEC)
    makeWordBold(hovered_global_wordnum)
    #if not time_to_linenum_wordnum_count[time]?
    #  time_to_linenum_wordnum_count[time] = []
    #if not time_to_linenum_wordnum_count[time][hovered_linenum]?
    #  time_to_linenum_wordnum_count[time][hovered_linenum] = []
    #if not time_to_linenum_wordnum_count[time][hovered_linenum][hovered_wordnum]?
    #  time_to_linenum_wordnum_count[time][hovered_linenum][hovered_wordnum] = 0
    time_to_gwordnum_count[time][hovered_global_wordnum] += 1
  else
    $('.bolded').css('font-weight', 'normal')
    $('.bolded').removeClass('bolded')
  prevX = newX
)

root.time_to_gwordnum = []

root.recomputeAlignment = ->
  root.time_to_gwordnum = compute_time_word_path(root.time_to_gwordnum_count)

root.onTimeChanged = (vid) ->
  time = Math.round(vid.currentTime * FRACSEC)
  #console.log time
  time_to_gwordnum = root.time_to_gwordnum
  if not time_to_gwordnum[time]?
    return
  gwordnum = time_to_gwordnum[time]
  makeWordBold(gwordnum)

