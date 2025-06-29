#!/usr/bin/env python3

import os
import sys
import json
import hashlib
from pathlib import Path


def calculate_file_md5(file_path):
    """Calcula o MD5 de um arquivo."""
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def should_ignore(file_path, ignore_paths):
    """Verifica se o arquivo deve ser ignorado."""
    for ignore_path in ignore_paths:
        if ignore_path and str(file_path).startswith(ignore_path):
            return True
    return False


def process_directory(source_dir, ignore_paths):
    """Processa recursivamente o diretório e calcula os MD5s."""
    md5_values = []

    # Converte para Path para manipulação mais fácil
    source_path = Path(source_dir)

    # Verifica todos os arquivos e diretórios recursivamente
    for root, dirs, files in os.walk(source_path):
        root_path = Path(root)

        # Processa cada arquivo
        for file in sorted(files):  # Ordena para garantir consistência
            file_path = root_path / file

            # Verifica se o arquivo deve ser ignorado
            if should_ignore(file_path, ignore_paths):
                continue

            # Calcula o MD5 do arquivo
            try:
                file_md5 = calculate_file_md5(file_path)
                md5_values.append(file_md5)
                print(f"Verificando: {file_path}")
            except Exception as e:
                print(f"Erro ao processar {file_path}: {e}", file=sys.stderr)

    # Concatena todos os valores MD5
    concatenated_md5 = "".join(md5_values)

    # Calcula o MD5 final
    final_md5 = hashlib.md5(concatenated_md5.encode()).hexdigest()

    return final_md5


def main():
    # Verifica se foi fornecido um argumento
    if len(sys.argv) != 2:
        print("Erro no parametro de entrada {\"source\": \"\", \"ignore_paths\": []}")

    try:
        # Carrega o objeto JSON
        config = json.loads(sys.argv[1])

        # Extrai os parâmetros
        ignore_paths = config.get("ignore_path", [])
        source_dir = config.get("source", "")

        if not source_dir:
            print("Erro: 'source' não especificado ou vazio", file=sys.stderr)
            sys.exit(1)

        # Mostra o diretório atual de execução
        current_dir = os.getcwd()
        print(f"Diretório atual de execução (pwd): {current_dir}")

        # Processa o diretório e calcula o MD5 final
        final_md5 = process_directory(source_dir, ignore_paths)

        # Imprime apenas o MD5 final
        print(f"\nMD5 final: {final_md5}")

    except json.JSONDecodeError:
        print("Erro: O argumento fornecido não é um JSON válido", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Erro: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()