+++
title = "Synchronized spectral CNN for 3D SHape Segmentation"
description = ""
tags = [
    "dl",
    "geo-dl",
    "presentation",
]
date = "2018-05-23"
categories = [
    "shihav",
    "geo-dl",
    "faces",
    "3d",
]
+++

# Shihav presentation

Presentation can be downloaded [**here**](http://geo-dl.compute.dtu.dk/presentations/asm01.pptx).

In this presenation Shihav presented a different approach compared to the multiview rendering and volumentric representations. The [spectral CNN approach (paper)](http://openaccess.thecvf.com/content_cvpr_2017/papers/Yi_SyncSpecCNN_Synchronized_Spectral_CVPR_2017_paper.pdf) is more focused on local represenation of points in a point cloud or a mesh. The method requires the graph laplacian and works by doing convolution as multiplication in the spectral domain. The in turn also yields a canonical representation of the 3D objects using functional maps. The functional maps paper will most likely be discussed in a future journal club meeting. The spectral decomposition of the mesh gives a good representation for working with clearly defined regions in a mesh, e.g. for segmentation like the authors present in this paper.

