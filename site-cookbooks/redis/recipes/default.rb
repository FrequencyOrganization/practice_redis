#設定値
package_name = "redis-#{redis_version}"
package_path = "#{Chef::Config[:file_cache_path]}/#{package_name}.tar.gz"
source_url = "http://download.redis.io/releases/redis-#{redis_version}.tar.gz"

#Download
remote_file package_path do
    source source_url
    not_if { File.exist?(package_path) }
end

bash "make redis and replace" do
  user 'vagrant'
  password 'vagrant'
  cwd '/home/vagrant'
  environment '/home/vagrant'
  code <<-EOC
    cd #{package_path}
    tar xzf redis-#{redis_version}.tar.gz
    cd redis-#{redis_version}
    make
  EOC
end
