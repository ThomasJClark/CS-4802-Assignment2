# CS 4802 Assignment 2 - Tree of Life
Thomas Clark

## Hierarchical Clustering
This program performs hierarchical clustering using a basic bottom-up agglomerative clustering algorithm.  The distance between two animals is defined as the number of fields besides "type" that are different between them, and the distance between one thing and an existing group is the average distance between each of the children in the group.

## Rendering the Tree
The data is drawn as a radial tree, only using the bottom 180° of the circle.  This was the best way I found to pack all of the data without having overlapping text.  Also, the way the branches spread out makes it easy to see clusters.

The thickness of the lines connected nodes in the tree is significant.  If the children of a group are very close together, the line connecting the children will be thicker.  This makes it possible to identify which connections indicate strong clusters and which connect relatively distance clusters together.

## Significance
### Biological
Moving the cursor over the name of an animal will highlight all animal names with a saturation related to how close it is to the selected animal.  This can be used to identify similarities and differences that are not immediately obvious from the tree structure.  

As an example, try mousing over "dolphin".  You'll notice two distinct clusters of red labels - mammals and fish.  This interaction reveals information about common traits across different groups that can't be intuitively derived from their positions on the tree alone.

### Technical
The interactive coloring is also a significant technical addition. In addition, the program features meaningful line thickness, and a more advanced layout than a typical tree.

## Running
This assignment was written in Coffeescript, and a Cakefile is provided to compile it.  Assuming `npm` is installed:

    $ git clone https://github.com/ThomasJClark/CS-4802-Assignment2
    $ cd CS-4802-Assignment2
    $ sudo npm install -g coffee-script
    $ cake build

To view, open a2.html in either Firefox or Chrome.  If using Chrome, pass it the `--disable-web-security` option, which is necessary to load the .csv file locally.
