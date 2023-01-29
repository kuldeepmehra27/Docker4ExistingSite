# Docker for existing drupal site
  Docker compose and env file for drupal existing site.

# Directory structure
<pre>
Docker4ExistingSite # Main repo
    │
    ├── <b>docker-compose.yml</b> # This is docker compose file
    ├── drupal8 # This is drupal 8 project
    │   ├── Drupal project files & directries
    |   ├── <b>DockerData</b>
    │   |   ├── credentials # This contain password txt file
    │   |   ├── data
    |   |   |   ├── db # This is for mount database
    |   |   |   └── dump # This contain sql & other files
    │   |   └── docker-configs
    |   └── <b>Dockerfile</b> # Project docker file
    └── <b>.env</b> # Environment variables files, variables used by docker compose file
</pre>

# Installation & veryfication instructions
  1. First veriy docker & docker compose version
  
     $ **docker -v && docker compose version**
     
       Docker version 20.10.23, build 7155243
       
       Docker Compose version v2.15.1
   
  2. Now run docker compose command to build cotainers
  
     $ **docker compose up -d --build**
     
     It will return following results:
     
     ```
     [+] Running 10/10
	 ⠿ Network drupal8_network    Created         0.0s
	 ⠿ Volume "drupal8_vendor"    Created         0.0s
	 ⠿ Volume "drupal8_modules"   Created         0.0s
	 ⠿ Volume "drupal8_themes"    Created         0.0s
	 ⠿ Volume "drupal8_profiles"  Created         0.0s
	 ⠿ Volume "drupal8_sites"     Created         0.0s
	 ⠿ Volume "drupal8_core"      Created         0.0s
	 ⠿ Container drupal8-PMA      Started         2.4s
	 ⠿ Container drupal8-db       Started         2.3s
	 ⠿ Container drupal8          Started         2.9s
     ```
  
   **Note:** Run this command at first/main level of repo.
   

  3. Use below command to verify running containers
  
     $ **docker ps**
   
     Last colunm **(Names) are containers**. It will return following results: 

<pre>
  <b>CONTAINER ID   IMAGE         COMMAND            CREATED      STATUS                 PORTS                                    NAMES</b>
    ID   drupal8-drupal   "/usr/sbin/apachectl…"    1 min ago    Up 2 mins       0.0.0.0:82->80/tcp, :::82->80/tcp              <b>drupal8</b>
    ID   phpmyadmin:5.2.0   "/docker-entrypoint.…"  1 min ago    Up 2 mins       0.0.0.0:8080->80/tcp, :::8080->80/tcp          <b>drupal8-PMA</b>
    ID   mariadb:10.5.9     "docker-entrypoint.s…"  1 min ago    Up 2 mins(healthy)   0.0.0.0:3307->3306/tcp, :::3307->3306/tcp <b>drupal8-db</b>
</pre>

  4. To login specific container use below command
  
     $ **docker exec -it drupal8 /bin/bash**
    
  5. Browse http://localhost:82 for drupal site (admin user & pass: admin & admin, Auth user & pass: user & user)
     http://localhost:8080 for phpmyadmin (username: root & password: root)
     
  6. If we updated any module or theme files so we need to rebuild conainter using below command we can rebuild container
  
     $ **docker compose build**
     
     **Note:** If face this issue failed to solve: error from sender: open /var/www/html/Docker4ExistingSite/drupal8/DockerData/data/db/drupal8: permission denied go to this location **/Docker4ExistingSite/drupal8/DockerData/data/db** and remove all files and dirs.
     
  7. To down docker site, remove volume & network use below command
  
     $ **docker compose down && docker system prune -a --volumes**

  If database not imported succefully so either we can use phpmyadmin or below commands
  <pre>
     <b>Syntax</b>
     
     1. docker exec -i [mysql_container_name] mysql -u[username] -p[password] [DB name] < [path/to/sql/file]
       <i>Ex:</i> docker exec -i drupal8-db mysql -uroot -prootpass drupal8 < drupal8/DockerData/data/dump/drupal8.sql

     2. cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE
        <i>Ex:</i> cat drupal8/DockerData/data/dump/drupal8.sql | docker exec -i drupal8-db /usr/bin/mysql -u root --password=rootpass drupal8
  </pre>
