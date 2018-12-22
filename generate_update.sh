#!/bin/bash 
 	git pull origin hexo  //先pull完成本地与远端的融合
	#hexo new post " new blog name"
	#git add source
	git add .
	git commit -m "XX"
	git push origin hexo
	hexo d -g
