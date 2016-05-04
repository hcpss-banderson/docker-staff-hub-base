FROM banderson/docker-moodle-webserver

MAINTAINER brendan_anderson@hcpss.org

LABEL vendor=Howard\ County\ Public\ Schools \
  org.hcpss.version="1.0.0" \
  org.hcpss.name="hub_web_base"
  
ARG GITHUB_TOKEN
  
ADD ansible /srv/provisioning
ADD manifest /srv/manifest

# Run the provisioning playbook. Variables related to the environment mode are
# stored in seperate YAML files in /srv/provisioning/vars/environments. 
# Acceptable modes are "dev", "stage" and "prod".
RUN apt-get install -y git \
  && ansible-galaxy install -r /srv/provisioning/requirements.yml \
  && ansible-playbook /srv/provisioning/provision.yml -c local \
  --extra-vars="github_access_token=${GITHUB_TOKEN}"

# Remove ansible and provisioning locations, which may contain secrets
RUN rm -rf /srv/provisioning && rm -rf /srv/manifest

COPY docker-entrypoint.sh /entrypoint-staff.sh

ENTRYPOINT ["/entrypoint-staff.sh"]

EXPOSE 80
CMD ["apache2-foreground"]
