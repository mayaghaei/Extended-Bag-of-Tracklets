# Extended-Bag-of-Tracklets

This is the implementation of the paper "Multi-face tracking by extended bag-of-tracklets in egocentric photo-streams" which is meant to be for research purpose only. If you used the code, please cite the paper.

@article{aghaei2016multi,
  title={Multi-face tracking by extended bag-of-tracklets in egocentric photo-streams},
  author={Aghaei, Maedeh and Dimiccoli, Mariella and Radeva, Petia},
  journal={Computer Vision and Image Understanding},
  volume={149},
  pages={146--156},
  year={2016},
  publisher={Elsevier}
}

Creater & Maintainer,
Maedeh Aghaei

# How to use the code:

1- Put imagese of the sequence into folder "data", inside the folder "[sequece number]".

2- Open the main.m function and set the paths.

3- Run the main.m function.

4- Final prototypes are saved in the folder "prototype" inside the folder "output".

Note: We set all thresholds as indicated in the paper and kept them fixed through all the experiments. However, they have been tuned to optimize the performances on our dataset. For different datasets, a tuning might be required.
Also, this code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# ACKNOWLEDGEMENTS

* The deepmatching code folder included is provided by Philippe Weinzaepfel et al. and downloaded from (http://lear.inrialpes.fr/src/deepmatching/). The corresppodning paper for citation is:

@inproceedings{weinzaepfel:hal-00873592,
  AUTHOR = {Weinzaepfel, Philippe and Revaud, Jerome and Harchaoui, Zaid and Schmid, Cordelia},
  TITLE = {{DeepFlow: Large displacement optical flow with deep matching}},
  BOOKTITLE = {{IEEE Intenational Conference on Computer Vision (ICCV)}},
  YEAR = {2013},
  MONTH = Dec,
  ADDRESS = {Sydney, Australia},
  URL = {http://hal.inria.fr/hal-00873592}
}

* The SparseFlow code folder included is provided by Radu Timofte et al. and downloaded from (http://www.vision.ee.ethz.ch/~timofter/). The corresppodning paper for citation is:

@inproceedings{timofte2015sparse,
  title={Sparse flow: Sparse matching for small to large displacement optical flow},
  author={Timofte, Radu and Van Gool, Luc},
  booktitle={2015 IEEE Winter Conference on Applications of Computer Vision},
  pages={1100--1106},
  year={2015},
  organization={IEEE}
}

* The faceDetector code folder included is provided by Xiangxin Zhu et al. and downloaded from (https://www.ics.uci.edu/~xzhu/face/). The corresppodning paper for citation is:

@inproceedings{zhu2012face,
  title={Face detection, pose estimation, and landmark localization in the wild},
  author={Zhu, Xiangxin and Ramanan, Deva},
  booktitle={Computer Vision and Pattern Recognition (CVPR), 2012 IEEE Conference on},
  pages={2879--2886},
  year={2012},
  organization={IEEE}
}
  
