Image `stuartfenton/teamcity-agent`

Teamcity agent 9.0.2 with extra build tools `php, php5-curl, phpUnit, phing, ruby, mercurial, zip, apache ant, node, npm & grunt`

Run teamcity docker image ``stuartfenton/teamcity-server` followed by this docker image. Change `teamcity-server.com:8111` to the name of your teamcity server.

Then run the agent like this:
`docker run -e TEAMCITY_SERVER=http://teamcity-server.com:8111 --link teamcity-server:teamcity-server --privileged=true --name="teamcity-agent" -dt stuartfenton/teamcity-agent`

If you want see the output logs change -dt to -it
`docker run -e TEAMCITY_SERVER=http://teamcity-server.com:8111 --link teamcity-server:teamcity-server --privileged=true --name="teamcity-agent" -it stuartfenton/teamcity-agent`

To use a host volume add `-v /home-teamcity-agent:/data`. This will mount the host volume `/teamcity-agent-data` to the the containers image `/data`

`docker run -v /teamcity-agent-data:/data -e TEAMCITY_SERVER=http://jobtasking.com:8111 --link teamcity-server:teamcity-server --privileged=true --name="teamcity-agent" -dt stuartfenton/teamcity-agent`

This makes it very easy to debug any build as you can see the agent's "temp" and "work" folder. When your done debugging. Run the image without the mounted volume so you can run multiple agents without them overwriting each others data.