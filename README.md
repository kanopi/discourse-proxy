# Discourse with Proxy

The following is a Docker Compose template for installing Discourse with a Nginx Proxy in front. The proxy has a Let's Encrypt Companion so that a valid ssl certificate can be installed.

## Requirements

Before installing there are two requirements.

### Docker

Installing Docker can usually be done can usually be done running the following command on most Linux systems.

```bash
curl -fsSL get.docker.com | sh
```

For other systems consult with the [Get Docker](https://docs.docker.com/install/overview/) page.

### Docker Compose

Docker Compose can be installed on most systems. To quickly install on Linux use the following commands:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Otherwise consult the [Docker Compose Install Page](https://docs.docker.com/compose/install/).

## Pulling

Clone the following project into the system.

```bash
git clone https://github.com/kanopi/osce-discourse.git discourse
```

## Configuring

### 1. Environment Variables

```bash
cp .env.sample .env
```

Edit the variables within the `.env` file as these will be necessary before setting up the site.

### 2. Configuring Nginx

Generate the Nginx configuration. Copy the template provided below to `etc/nginx/discourse.conf`.

Local Development use `etc/nginx/discourse.conf.local`.
Production Development use `etc/nginx/discourse.conf.prod`.

Edit and replace the `www.example.com` with the hostname provided.

### 3. Let's Encrypt

Run the Let's Encrypt Init script so that the certificates can be generated. Running the follow command will work and replace the domain names `www.example.com` and `example.com` with any other domains that will need to be generated.

```bash
./init-letsencrypt.sh example.com www.example.com
```

**NOTE** This step can be skipped if not configuring on a public network as Let's Encrypt will only work with publicly accessible servers.

### 4. Start Stack

Once the following steps are done. Start the stack by running the following `docker-compose` command.

```bash
docker-compose up -d
```

## Troubleshooting

### Checking the Status

To check the status of all of the containers.

```bash
docker-compose ps
```

This should produce output like the following below. All containers should have a status of `Up`.

```
           Name                          Command               State                    Ports
---------------------------------------------------------------------------------------------------------------
discourse_certbot_1      /bin/sh -c trap exit TERM; ...   Up      443/tcp, 80/tcp
discourse_discourse_1    /app-entrypoint.sh nami st ...   Up      3000/tcp
discourse_nginx_1        /bin/sh -c while :; do sle ...   Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp
discourse_postgresql_1   /app-entrypoint.sh /run.sh       Up      5432/tcp
discourse_redis_1        /entrypoint.sh /run.sh           Up      6379/tcp
discourse_sidekiq_1      /app-entrypoint.sh nami st ...   Up      3000/tcp
```

### Reviewing the Logs

Logs can be viewed using `docker-compose`.

```
docker-compose logs
```

For more information on logs or logs for specific services. `docker-compose help logs`.

### How to change user 1 email

If the email address wasn't set previously it can be changed by executing the following.

```bash
docker-compose exec postgresql sh
psql bitnami_application bn_discourse
UPDATE user_emails SET email = 'user@example.com' WHERE id=1 AND user_id=1;
```
