#!/bin/bash
tar xvfz tar/prometheus-2.37.6.linux-amd64.tar.gz
# rm prometheus-*.tar.gz
sudo mkdir /etc/prometheus /var/lib/prometheus
cd prometheus-2.37.6.linux-amd64
sudo cp prometheus promtool /usr/local/bin/
#sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo cp -r consoles/ console_libraries/ /etc/prometheus/
prometheus --version
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus
cd ..
sudo cp configs/prometheus.yml /etc/prometheus/prometheus.yml
sudo chcon -t bin_t /usr/local/bin/prometheus
sudo cp services/prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus | head -n 15

#nodeexporter
tar xvfz tar/node_exporter-*.tar.gz
sudo cp node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin
sudo useradd -rs /bin/false node_exporter
sudo chcon -t bin_t /usr/local/bin/node_exporter
sudo cp services/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl enable node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter | head -n 15

#grafana
sudo dpkg -i deb/*
sed -i '0,/"id": .*/{s/"id": .*/"id": null,/}' grafana-dashboards/*.json
sudo cp configs/grafana.ini /etc/grafana/grafana.ini
sudo cp configs/datasources.yaml /etc/grafana/provisioning/datasources/datasources.yml
sudo cp grafana-dashboards/* /etc/grafana/provisioning/dashboards
sudo chown grafana /etc/grafana/provisioning/dashboards/*
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server | head -n 15
