#設定値
package_name = "redis-#{node["redis"]["version"]}"
download_directory = "#{Chef::Config[:file_cache_path]}"
package_path = "#{download_directory}/#{package_name}.tar.gz"
source_url = "http://download.redis.io/releases/#{package_name}.tar.gz"

#Download
remote_file package_path do
    source source_url
    not_if { File.exist?(package_path) }
end

bash "make redis and replace" do
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
  environment "HOME" => '/home/vagrant'
  code <<-EOC
    cd #{download_directory}
    sudo tar xzf #{package_name}.tar.gz
    cd #{package_name}
    sudo make test
    sudo make install
  EOC
end

# サービスを起動する
bash "start_redis_server" do
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
  code <<-EOH
    /usr/local/bin/redis-server &
  EOH
  not_if "ps aux | grep \[r\]edis-server"
end

