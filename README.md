# FlickrParlaxDemo 
Code for Flickr's intro paralax walkthrough article

![](./animation.gif)

# How to Install or update the cocoa pods dependencies

In terminal naviate to the project's directory and then type:

`pod install`

#Enjoy

All of the AutoLayout constraints are held in the Story board, to declutter the ViewController.

The ParalaxHelper class can be used to configure some more pages if you wish:
just pass him the parallax page views, paths and animation translation values(offsets - how far will the views go)

```
let paths:[CGPath] = [circlePathForSize(personView.frame.size), circlePathForSize(box1View.frame.size), circlePathForSize(box2View.frame.size), circlePathForSize(box3View.frame.size), circlePathForSize(box4View.frame.size), circlePathForSize(box5View.frame.size), circlePathForSize(box6View.frame.size)]


let views:[UIView] = [personView, box1View, box2View, box3View, box4View, box5View, box6View]
let offsets:[CGFloat] = [1100, 400, 550, 300, 400, 500, 20]

let paralax = ParalaxHelper.init(animator: animator, views: views, paths: paths, offsets: offsets, width: view.frame.size.width, margin: 0)

paralax.configure()
```

And you are also not limited to use circle or oval paths as view mask, you could make custom shapes with PainCode and include them here as bezier paths.
