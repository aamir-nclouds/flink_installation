apt_package 'unzip' do
    action :install 
end

execute 'flink_stop' do
    command 'sudo bash /flink-1.11.1/bin/stop-cluster.sh'
    action :run
end

remote_file '/tmp/Updated-Flink.tgz' do
    source "https://#{node['s3Bucket']['name']}/#{node['Flink_Updated_Pkg']['name']}"
    mode '0777'
    action :create
end

execute 'extract_flink' do
    command 'tar zxvf /tmp/Updated-Flink.tgz'
    action :run
end

execute 'move_conf' do
    user "root"
    command 'sudo mv Updated-Flink/conf/flink-conf.yaml /flink-1.11.1/conf'
    action :run
end
  
execute 'move_log' do
    user "root"
    command 'sudo mv Updated-Flink/conf/log4j.properties /flink-1.11.1/conf'
    action :run
end

execute 'flink_start' do
    command 'sudo bash /flink-1.11.1/bin/start-cluster.sh'
    action :run
end