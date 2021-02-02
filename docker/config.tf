provider "docker" {
  host = "ssh://ubuntu@10.0.0.50:22"
}

resource "docker_image" "nginx" {
  name = "nginx"
}

resource "docker_container" "nginx-server" {
  name  = "nginx-server"
  image = docker_image.nginx.latest
  ports {
    internal = 80
  }
  volumes {
    container_path = "/usr/share/nginx/html"
    host_path      = "/vol/"
    read_only      = true
  }
}

