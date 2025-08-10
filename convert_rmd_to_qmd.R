library(stringr)
library(readr)
library(fs)

convert_rmd_to_qmd <- function(input_path, output_path = NULL) {
  # Leer contenido
  lines <- read_lines(input_path)

  # Detectar y extraer YAML
  yaml_start <- which(lines == "---")[1]
  yaml_end <- which(lines == "---")[-1][1]

  # Reemplazar YAML por uno compatible con Quarto Revealjs
  new_yaml <- c(
    "---",
    "title: \"Título de la presentación\"",
    "format: revealjs",
    "revealjs:",
    "  theme: [default, cide.css]",
    "  css: cide.css",
    "  slide-number: true",
    "  scrollable: false",
    "  aspectRatio: 16:9",
    "  include-before-body: https://platform.twitter.com/widgets.js",
    "---"
  )

  # Extraer contenido sin YAML original
  content <- lines[-c(yaml_start:yaml_end)]

  # Combinar nuevo YAML con contenido
  final_lines <- c(new_yaml, "", content)

  # Definir ruta de salida
  if (is.null(output_path)) {
    output_path <- path_ext_set(input_path, "qmd")
  }

  # Escribir archivo .qmd
  write_lines(final_lines, output_path)

  message("✅ Archivo convertido: ", output_path)
}


for(i in c(29)){
  path = paste0("diapositivas/clase_",i,".Rmd")
  convert_rmd_to_qmd(path)
}

