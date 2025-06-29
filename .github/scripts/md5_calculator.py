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


def should_ignore(path, ignore_paths):
    """Verifica se um caminho deve ser ignorado."""
    path_str = str(path)
    for ignore_path in ignore_paths:
        if ignore_path and (path_str == ignore_path or path_str.startswith(ignore_path + os.sep)):
            return True
    return False


def process_directory(source_dir, ignore_paths):
    """
    Processa recursivamente um diretório, calculando o MD5 de cada arquivo
    e ignorando os caminhos especificados.
    """
    md5_values = []
    source_path = Path(source_dir).resolve()

    # Converte ignore_paths para caminhos absolutos
    absolute_ignore_paths = [str(Path(source_dir, p).resolve()) for p in ignore_paths if p]

    for root, dirs, files in os.walk(source_path):
        root_path = Path(root)

        # Remove diretórios a serem ignorados da lista de diretórios a percorrer
        dirs[:] = [d for d in dirs if not should_ignore(root_path / d, absolute_ignore_paths)]

        for file in sorted(files):  # Ordena para garantir consistência
            file_path = root_path / file
            if not should_ignore(file_path, absolute_ignore_paths):
                try:
                    file_md5 = calculate_file_md5(file_path)
                    md5_values.append(file_md5)
                except Exception as e:
                    print(f"Erro ao processar o arquivo {file_path}: {e}", file=sys.stderr)

    # Concatena todos os valores MD5 e calcula o MD5 final
    concatenated_md5 = "".join(md5_values)
    final_md5 = hashlib.md5(concatenated_md5.encode()).hexdigest()

    return final_md5


def main():
    """Função principal que processa os argumentos e executa o script."""
    if len(sys.argv) != 2:
        print("Erro no parametro de entrada {\"source\": \"\", \"ignore_paths\": []}")
        sys.exit(1)

    try:
        config = json.loads(sys.argv[1])
        source_dir = config.get("source", "")
        ignore_paths = config.get("ignore_path", [])

        if not source_dir:
            print("Erro: 'source' não especificado ou vazio", file=sys.stderr)
            sys.exit(1)

        if not os.path.isdir(source_dir):
            print(f"Erro: O diretório '{source_dir}' não existe", file=sys.stderr)
            sys.exit(1)

        final_md5 = process_directory(source_dir, ignore_paths)
        print(final_md5)

    except json.JSONDecodeError:
        print("Erro: Argumento JSON inválido", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Erro inesperado: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()