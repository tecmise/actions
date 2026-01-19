from __future__ import annotations
from typing import List, Optional, Dict
from dataclasses import dataclass, field
import os


@dataclass
class Method:
    name: str
    authorization: Optional[str] = None
    authorizer_id: Optional[str] = None
    uri: Optional[str] = None
    api_key_required: Optional[bool] = None
    integration_type: Optional[str] = None
    integration_http_method: Optional[str] = None
    integration_response_http_method: Optional[str] = None
    roles: Optional[List[str]] = None

@dataclass
class Route:
    id: str
    path: str
    methods: Optional[List[Method]] = None
    cors: Optional[bool] = None
    parent_id: Optional[str] = None
    children: List['Route'] = field(default_factory=list)

    def get_integration_request_parameters(self, map: Dict[str, Route]) -> List[str]:
        integration_request_parameters = []
        if self.parent_id is not None:
            parent = map[self.parent_id]
            list = parent.get_integration_request_parameters(map)
            if list is not None and len(list) > 0:
                integration_request_parameters.extend(list)

        if self.path[0] == "{" and self.path[-1] == "}":
            content = f"\"integration.request.path.{self.path[1:-1]}\" = \"method.request.path.{self.path[1:-1]}\""
            if not integration_request_parameters.__contains__(content):
                integration_request_parameters.append(content)

        return integration_request_parameters


    def get_method_request_parameters(self, map: Dict[str, Route]) -> List[str]:
        method_request_parameters = []
        if self.parent_id is not None:
            parent = map[self.parent_id]
            list = parent.get_method_request_parameters(map)
            if list is not None and len(list) > 0:
                method_request_parameters.extend(list)

        if self.path[0] == "{" and self.path[-1] == "}":
            content = f"\"method.request.path.{self.path[1:-1]}\" = true"
            if not method_request_parameters.__contains__(content):
                method_request_parameters.append(content)

        return method_request_parameters

    def __post_init__(self):
        # Se methods for None, não fazer nada
        if not self.methods:
            return

        # Inicializar uma lista para os métodos convertidos
        converted_methods = []

        for m in self.methods:
            if isinstance(m, str):
                meth = Method(name=m)
            elif isinstance(m, dict):
                meth = Method(**m)
            elif isinstance(m, Method):
                meth = m
            else:
                continue

            if meth.uri.endswith("__") and meth.uri.startswith("__"):
                key = meth.uri.replace("__", "")
                print(f"Substituindo URI do método {meth.name} pelo valor da variável de ambiente: {key}")
                env_value = os.getenv(key)
                meth.uri = meth.uri.replace(key, env_value)

            converted_methods.append(meth)

        # Substituir a lista original pela lista convertida
        self.methods = converted_methods