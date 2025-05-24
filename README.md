# WpPrestaFusion
Fusion aus WordPress & PrestaShop mit Kubernetes & CI/CD

## Kontext
Ein DevOps & Cloud Architektur Trainingsprojekt, das eine containerisierte Webapplikation mit mehreren Umgebungen (Dev, Staging, Prod) auf AWS bereitstellt. Die Lösung basiert auf modernen DevOps-Praktiken wie IaC, CI/CD, Orchestrierung und Observability.

## Ziele
- Automatisierte Bereitstellung via IaC und PaC
- Hochverfügbarkeit, Skalierbarkeit, Sicherheit
- Vollständige CI/CD-Pipeline für alle Umgebungen
- Observability & Disaster Recovery integriert

## Umfang
- Zwei Webserver (WordPress & PrestaShop)
- NGINX Load Balancer
- Kubernetes-Orchestrierung
- Terraform für AWS-Infrastruktur
- Monitoring mit Prometheus & Grafana

## Architekturkomponenten
| Komponente     | Rolle                      | Technologie         |
|----------------|----------------------------|---------------------|
| WordPress       | CMS                       | PHP, MariaDB, Docker |
| PrestaShop      | CMS                       | PHP, MariaDB, Docker |
| Load Balancer   | Traffic-Verteilung        | NGINX                |
| Datenbank       | Persistenz                | MariaDB              |
| CI/CD           | Automatisierung           | GitHub Actions       |
| IaC             | Infrastruktur-Management  | Terraform, AWS       |
| Observability   | Logs & Metriken           | Prometheus, Grafana  |
| Sicherheit      | Schutz & Zugriff          | IAM, TLS, Secrets    |

## Branching-Strategie
- \`main\`: stabile Produktionsversion
- \`release\`: staging + deployment-Vorbereitung

## Repositoriestruktur
Mono-Repo mit Unterordnern für:
- App-Services
- Kubernetes-Manifeste
- IaC-Terraform-Struktur
- CI/CD-Pipelines
- Doku & Tests

## "Everything as Code"
- **IaC**: Terraform für Infrastruktur
- **CaC**: Kubernetes YAMLs für Konfiguration
- **PaC**: GitHub Actions für Deployment

## Sicherheit
- TLS (HTTPS) via cert-manager / Let's Encrypt
- IAM + RBAC + Secrets-Management
- Network Policies + Firewall-Regeln

## Observability
- Zentralisiertes Logging (z. B. Loki, EFK)
- Metriken + Dashboards (Prometheus + Grafana)
- Alerts (z. B. Alertmanager)

## Wiederherstellung & Verfügbarkeit
- S3-Backups
- Multi-AZ Deployments
- Auto-Healing via K8s

