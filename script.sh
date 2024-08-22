#!/bin/bash
tar xvfz tar/prometheus-2.37.6.linux-amd64.tar.gz
# rm prometheus-*.tar.gz
sudo mkdir /etc/prometheus /var/lib/prometheus
cd prometheus-2.37.6.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mv consoles/ console_libraries/ /etc/prometheus/
prometheus --version
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus
sudo mv services/prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus
cd ..

#nodeexporter
tar xvfz tar/node_exporter-*.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin
sudo useradd -rs /bin/false node_exporter
sudo mv services/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl enable node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter

#grafana
sudo dpkg -i *.deb
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server
