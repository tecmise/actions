import hashlib
import json
import os
import sys


def should_ignore(file_path, ignore_paths):
    """Verifica se um caminho deve ser ignorado com base nas regras de ignorar."""
    for ignore_path in ignore_paths:
        # Verifica se o caminho começa com algum dos padrões de ignorar
        if any(part == ignore_path for part in file_path.split(os.sep)):
            # print(f"Ignorando: {file_path} (corresponde a {ignore_path})")
            return True
    return False


def calculate_md5(directory, ignore_paths):
    """Calcula o hash MD5 de todos os arquivos em um diretório, excluindo os ignorados."""
    # print(f"Diretório atual de execução (pwd): {os.getcwd()}")

    md5_hash = hashlib.md5()
    file_list = []

    # Percorre o diretório recursivamente
    for root, dirs, files in os.walk(directory):
        # Remove diretórios ignorados da lista de diretórios a serem percorridos
        dirs[:] = [d for d in dirs if not should_ignore(os.path.join(root, d), ignore_paths)]

        for file in sorted(files):
            file_path = os.path.join(root, file)
            rel_path = os.path.relpath(file_path, directory)

            if should_ignore(rel_path, ignore_paths):
                continue

            # print(f"Processando: {file_path}")

            try:
                with open(file_path, 'rb') as f:
                    content = f.read()
                    md5_hash.update(content)
                file_list.append(rel_path)
            except Exception as e:
                print(f"Erro ao processar {file_path}: {e}")

    # Adiciona a lista de arquivos ao hash para garantir que mudanças na estrutura de arquivos também afetem o hash
    md5_hash.update(",".join(file_list).encode())

    return md5_hash.hexdigest()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Erro no parametro de entrada {\"source\": \"\", \"ignore_paths\": []}")
        sys.exit(1)

    config = json.loads(sys.argv[1])
    ignore_paths = config.get("ignore_path", [])
    source_dir = config.get("source", ".")

    hash_value = calculate_md5(source_dir, ignore_paths)
    print(hash_value)