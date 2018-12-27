#!/bin/bash 
 	git pull origin hexo  
	#hexo new post " new blog name"
	#git add source
	git add .
	git commit -m "XX"
	git push origin hexo
	hexo d -g
