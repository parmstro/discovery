# discovery
Quick setup for discovery tool for inventorying your RHEL environment.
For now we use the discovery_install, discovery_start, discovery_stop bash scripts.

develop branch discovery ansible module to deliver and configure discovery point of presense.

Idealized workflow:
  - install the discovery system on one or more hosts
  - define sources and credenitials for sources
  - define and launch scans for sources
  - export and submit scan results to console dot, get receipt
  - archive the scan results to an archive folder
  - uninstall the discovery system from hosts
