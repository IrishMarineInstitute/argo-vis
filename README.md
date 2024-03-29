# argo-vis
Repository for visualising Argo float deployments through time in video

## Acknowledgments

<span style="background-color:#fff;"><img src="https://raw.githubusercontent.com/IrishMarineInstitute/zapidox/master/img/dafm.png" alt="DAFM Logo" style="height: 50px;"/> <img src="https://raw.githubusercontent.com/IrishMarineInstitute/zapidox/master/img/forasnamara.jpg" alt="Marine Institute Logo" style="height: 50px;"/> <img src="https://raw.githubusercontent.com/IrishMarineInstitute/zapidox/master/img/eu-emff.png" alt="EU EMFF Logo" style="height: 50px;"/> <img src="https://raw.githubusercontent.com/IrishMarineInstitute/zapidox/master/img/eu_sifp.jpg" alt="EU Structural Infrastructure Fund and Programme Logo" style="height: 50px;"/></span>

This application runs in docker to generate mp4 video animations from [argo](http://www.argo.ucsd.edu/) data 1998-now

The Marine Institute specific use case is to display the data on a [Pufferfish display](https://pufferfishdisplays.com/)

![alt text](example.gif "Example")

Full videos can be [downloaded here](http://spiddal.marine.ie/argos/).

# Installing

```shell
git clone https://github.com/IrishMarineInstitute/argo-vis.git
cd argo-vis
docker build -t timecut .

```

# Running
```
bin/argoanim.sh

```

If it all works, you will find the mp4 videos in the output folder. The whole process may take a couple of hours, running longer the first time as historical data must be fetched first.

# How it works

After downloading the argo data, the animation simply a html+javascript application made to run in a web browser. The animation is converted to video using [timecut](https://github.com/tungs/timecut).
