buildSpinner({x : 8, y : 8, size : 5, degrees : 12})

buildSpinner = (data) ->
  canvas = document.createElement('canvas')
  canvas.height = data.y
  canvas.width = data.x
  document.getElementsByTagName('article')[0].appendChild(canvas)
  #ctx = canvas.getContext("2d"), i = 0, degrees = data.degrees, loops = 0, degreesList = []

  degreesList.push(i) for i in [0..degrees]
  i = 0
  window.canvasTimer = setInterval(draw, 1000/degrees)

  reset ->
    ctx.clearRect(0,0,100,100)
    left = degreesList.slice(0, 1)
    right = degreesList.slice(1, degreesList.length)
    degreesList = right.concat(left)

  draw ->
    d = 0
    reset() if i == 0
    ctx.save()

    d = degreesList[i]
    c = Math.floor(255/degrees*i)
    ctx.strokeStyle = 'rgb(' + c + ', ' + c + ', ' + c + ')'
    ctx.lineWidth = data.size
    ctx.beginPath()
    s = Math.floor(360/degrees*(d))
    e = Math.floor(360/degrees*(d+1)) - 1

    ctx.arc(data.x, data.y, data.size, (Math.PI/180)*s, (Math.PI/180)*e, false)
    ctx.stroke()

    ctx.restore()

    i++
    i = 0 if (i >= degrees)

