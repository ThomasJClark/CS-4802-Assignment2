# a2.coffee: main rendering functions for assignment 2.
#
# Thomas Clark - CS 4802 Assignment 2

treeData = undefined

svg = (d3.select 'body').append 'svg:svg'
  .attr
    width: 1280
    height: 720
    preserveAspectRatio: 'none'
  .style
    display: 'block'
    margin: 'auto'

tree = d3.layout.tree()
  .size [360, 700]
  .value (d) -> d.animalname
  .children (d) -> d.children

treeGroup = svg.append 'g'
  .attr 'transform', 'translate(640, 10)'

diagonal = d3.svg.diagonal.radial()
  .projection (d) -> [d.y, (d.x + 180) / 180 * Math.PI / 2]

render = () ->
  nodeData = tree.nodes treeData
  linkData = tree.links nodeData

  # Render links as paths
  link = treeGroup.selectAll 'g.link'
    .data linkData
    .enter()
    .append 'g'
    .attr
      class: 'link'

  link.append 'path'
    .attr
      d: diagonal
    .style
      fill: 'none'
      stroke: 'black'

  # Transform nodes to
  node = treeGroup.selectAll 'g.node'
    .data nodeData
    .enter()
    .append 'g'
    .attr
      class: 'node'
      transform: (d) -> "rotate(#{ d.x / 2 }) translate(#{ d.y })"

  # Add text labels to all nodes that are not groups
  textGroup = (node.filter (d, i) -> not d.group).append 'g'
    .attr 'transform', (d) -> "rotate(#{ if d.x > 180 then 180 else 0 })"

  textGroup.append 'text'
    .text (d) -> d.animalname
    .attr
      'text-anchor': 'middle'
      'dominant-baseline': 'central'
    .style
      fill: 'Black'
      'font-size': '0.8em'
      'font-family': '"Helvetica Neue",Helvetica,Arial,sans-serif'

  textGroup.each (d, i) ->
    bbox = this.children[0].getBBox()
    (d3.select this).insert 'rect', ':first-child'
      .attr bbox
      .attr 'rx', 4
      .style
        fill: 'White'
        stroke: 'White'


d3.csv 'zoo.csv',
  (error, animals) ->
    treeData = cluster.bottomUpCluster animals
    render()
