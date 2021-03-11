library(tidyverse)
ggplot2::mpg
ggplot(mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))
view(mpg)

ggplot(data=mpg) #shows blank plot ##need aestethics
nrow(mpg) #number of rows=234
ncol(mpg) #number of col=11
?mpg #gives information, drv is the type of drive train, front, rear, 4
#make a scatterplot of hwy v cyl
ggplot(data=mpg)+
  geom_point(mapping = aes(x=hwy,y=cyl))

#make a scatterplot of class v. drv
ggplot(data=mpg)+
  geom_point(mapping = aes(x=class, y=drv))

#map class with color 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

#map class with size 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
# Warning: Using size for a discrete variable is not advised.

#can also map with aplha aes
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
#Warning message: Using alpha for a discrete variable is not advised. 

# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#maximum of 6 discrete values 

#mapping a color of all points in geom ##doesn't convey variable information. It just applies to all points
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

#Exercises 3.3.1
##whats wrong with this code? Why aren't they blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
### It's on the inside of aes. Should read
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
##Which variables are categorical and continuous 
?mpg ##Categorical=chr continuous=value 
##map a continuous variable color size and shape ###a continuous variable can not be mapped to shape
ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, color=drv, size=drv))
##what happens if you map the same variable to multiple aesthetics
ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, color=cty, size=cty, stroke=cty))
##what does the stroke aes do?
?geom_point
###makes bigger??
##What happens if you map an aesthetic to something other than variable name like aes(color=displ<5)
ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, color=displ<5))
###colors based on true or false whether above or below 5

#Example of Facet with a single variable 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
#Example of facet with two variables 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))+
  facet_grid(drv ~ cyl)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~.)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(.~ cyl)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
?facet_wrap
?facet_grid
