# Artisan Runtime Image for SonarQube Community Scanner

This image container the community [sonar scanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)
and can be used to scan application source code for quality metrics.

### Supported Languages

The community edition of the scanner supports the languages described in the table [here](https://docs.sonarqube.org/latest/analysis/languages/overview)

### Runtime Use

If no package name is specified, this runtime will execute [run.sh](run.sh), which will scan the source mounted in the image.

### Runtime Input

The runtime input information required by [run.sh](run.sh) is defined in the [input.yaml](input.yaml) file.

