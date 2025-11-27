import json
import sys
import uuid
from typing import List, Optional
from src.models.route import Route, Method


def parse_routes(json_string: str) -> List[Route]:
    data = json.loads(json_string)
    return [build_route_node(item) for item in data]


def build_route_node(data: dict, parent_id: Optional[str] = None) -> Route:
    node_id = data.get("id", str(uuid.uuid4()))
    node = Route(
        id=node_id,
        path=data["path"],
        methods=data.get("methods"),
        cors=data.get("cors"),
        parent_id=parent_id,
    )

    # Inicializa methods como uma lista vazia se for None
    if node.methods is None:
        node.methods = []

    # Adiciona OPTIONS como objeto Method se cors for True
    if node.cors and not check_method_name_already_exists(node.methods, "OPTIONS"):
        node.methods.append(Method(name="OPTIONS"))

    if "children" in data:
        for child_data in data["children"]:
            child_node = build_route_node(child_data, node_id)
            node.children.append(child_node)

    return node

def check_method_name_already_exists(methods: List, name: str) -> bool:
    for method in methods:
        if isinstance(method, str) and method == name:
            return True
        elif isinstance(method, dict) and method.get("name") == name:
            return True
        elif hasattr(method, 'name') and method.name == name:
            return True
    return False

def create_terraform_file(route: Route):
    filename = f"{route.id}.tf"
    with open(filename, "w", encoding="utf-8") as f:
        print(f"resource aws_api_gateway_resource {route.id}  {{", file=f)
        if route.parent_id is None:
            print(f"\tparent_id   = var.root_resource_id", file=f)
        else:
            print(f"\tdepends_on  = [aws_api_gateway_resource.{route.parent_id}]", file=f)
            print(f"\tparent_id   = aws_api_gateway_resource.{route.parent_id}.id", file=f)
        print(f"\trest_api_id = var.rest_api_id", file=f)
        print(f"\tpath_part   = \"{route.path}\"", file=f)
        print(f"}} ", file=f)

        if route.methods is not None:
            for method in route.methods:
                print(f" ", file=f)
                print(f"module \"{route.id}_{method.name.lower()}\" {{ ", file = f)
                print(f"   source                                       = \"git::https://github.com/tecmise/actions//terraform/api-gateway-resource-verbs?ref=v5.1.6\"", file = f)
                print(f"   resource_id                                  = aws_api_gateway_resource.{route.id}.id ", file=f)
                print(f"   rest_api_id                                  = aws_api_gateway_resource.{route.id}.rest_api_id ", file=f)
                print(f"   verb                                         = \"{method.name}\" ", file=f)
                print(f"   terraform_bucket                             = var.terraform_bucket ", file=f)



                print(f"   integration_request_parameters               = {{ ", file=f)
                print(f"     \"integration.request.header.target\"      = \"'${{var.application_name}}'\" ", file=f)
                print(f"   }} ", file=f)
                if method.uri is None:
                    print(f"   uri                                          = var.invoke_uri ", file=f)
                else:
                    print(f"   uri                                          = \"{method.uri}\" ", file=f)

                if method.api_key_required is None:
                    if method.name == "OPTIONS":
                        print(f"   api_key_required                             = false ", file=f)
                    else:
                        print(f"   api_key_required                             = true ", file=f)
                else:
                    print(f"   api_key_required                             = {method.api_key_required} ", file=f)


                if method.integration_type is None:
                    if method.name == "OPTIONS":
                        print(f"   integration_type                             = \"MOCK\" ", file=f)
                    else:
                        print(f"   integration_type                             = \"AWS_PROXY\" ", file=f)
                else:
                    print(f"   integration_type                             = \"{method.integration_type}\" ", file=f)



                if method.integration_http_method is None:
                    if method.name == "OPTIONS":
                        print(f"   integration_http_method                      = \"OPTIONS\" ", file=f)
                    else:
                        print(f"   integration_http_method                      = \"POST\" ", file=f)
                else:
                    print(f"   integration_http_method                      = \"{method.integration_http_method}\" ", file=f)


                if method.integration_response_http_method is None:
                    if method.name == "OPTIONS":
                        print(f"   integration_response_http_method             = \"OPTIONS\" ", file=f)
                    else:
                        print(f"   integration_response_http_method             = \"POST\" ", file=f)
                else:
                    print(f"   integration_response_http_method             = \"{method.integration_response_http_method}\" ", file=f)

                if method.name == "OPTIONS":
                    print(f"   has_integration_response                     = true ", file=f)
                else:
                    print(f"   has_integration_response                     = false ", file=f)

                print(f"   integration_response_status_code             = \"200\" ", file=f)
                print(f"   method_response_models                       = {{ ", file=f)
                print(f"     \"application/json\" = \"Empty\"                      ", file=f)
                print(f"   }} ", file=f)
                print(f"   method_request_parameters                    = {{}}", file=f)

                if method.authorization is None:
                    if method.name == "OPTIONS":
                        print(f"   authorization                                = \"NONE\" ", file=f)
                    else:
                        print(f"   authorization                                = \"CUSTOM\" ", file=f)
                else:
                    print(f"   authorization                                = \"{method.authorization}\" ", file=f)


                if method.vpc_link_name is not None and method.loadbalancer_name is not None:
                    if method.name != "OPTIONS":
                        print(f"   vpc_link_key                                = \"{method.loadbalancer_name}_{method.vpc_link_name}\" ", file=f)



                if method.authorizer_id is None:
                    if method.name == "OPTIONS":
                        print(f"   authorizer_id                                = \"\" ", file=f)
                    else:
                        print(f"   authorizer_id                                = var.authorizer_id ", file=f)
                else:
                    print(f"   authorizer_id                                = \"{method.authorizer_id}\" ", file=f)


                if method.roles is not None:
                    print(f"   roles                                = [ ", file=f)
                    for role in method.roles:
                        print(f" \"{role}\", ", file=f)
                    print(f"   ] ", file=f)

                if method.name == "OPTIONS":
                    print(f"   method_response_parameters                   = {{ ", file=f)
                    print(f"    \"method.response.header.Access-Control-Allow-Headers\" = true,", file=f)
                    print(f"    \"method.response.header.Access-Control-Allow-Methods\" = true,", file=f)
                    print(f"    \"method.response.header.Access-Control-Allow-Origin\" = true,", file=f)
                    print(f"   }} ", file=f)
                    print(f"   integration_response_response_parameters     = {{ ", file=f)
                    print(f"    \"method.response.header.Access-Control-Allow-Headers\" = \"'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token,X-Requested-With,Cache-Control'\",", file=f)
                    print(f"    \"method.response.header.Access-Control-Allow-Methods\" = \"'OPTIONS,GET,PUT,POST,DELETE,PATCH,HEAD'\",", file=f)
                    print(f"    \"method.response.header.Access-Control-Allow-Origin\" = \"'${{var.cors_origin_domain}}'\",", file=f)
                    print(f"   }} ", file=f)
                    print(f"   integration_request_templates                = {{ ", file=f)
                    print(f"   \"application/json\" = \"{{ statusCode: 200 }}\" ", file=f)
                    print(f"   }} ", file=f)
                else:
                    print(f"   method_response_parameters                   = {{}} ", file=f)
                    print(f"   integration_response_response_parameters     = {{}} ", file=f)
                    print(f"   integration_request_templates                = {{}} ", file=f)
                print(f"}} ", file=f)



def validate_duplicate_ids(routes: List[Route]):
    ids = set()

    def check_route(route: Route):
        if route.id in ids:
            raise ValueError(f"ID duplicado encontrado: {route.id}")
        ids.add(route.id)
        for child in route.children:
            check_route(child)

    for route in routes:
        check_route(route)


def process_all_routes(route: Route):
    create_terraform_file(route)
    for child in route.children:
        process_all_routes(child)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python script.py '<json_string>'")
        sys.exit(1)

    json_string = sys.argv[1]

    try:
        routes = parse_routes(json_string)

        if validate_duplicate_ids(routes):
            print("IDs duplicados encontrados. Abortando.")
            sys.exit(1)

        for route in routes:
            process_all_routes(route)

    except json.JSONDecodeError as e:
        print(f"Erro ao fazer parse do JSON: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Erro: {e}")
        sys.exit(1)