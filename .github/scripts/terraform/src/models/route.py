from typing import List, Optional, Union
from dataclasses import dataclass, field


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
    vpc_link_name: Optional[str] = None

@dataclass
class Route:
    id: str
    path: str
    methods: Optional[List[Method]] = None
    cors: Optional[bool] = None
    parent_id: Optional[str] = None
    children: List['Route'] = field(default_factory=list)

    def __post_init__(self):
        # Se methods for None, não fazer nada
        if not self.methods:
            return

        # Inicializar uma lista para os métodos convertidos
        converted_methods = []

        for m in self.methods:
            if isinstance(m, str):
                # Se for string, criar objeto Method apenas com o nome
                converted_methods.append(Method(name=m))
            elif isinstance(m, dict):
                # Se for dicionário, criar objeto Method com todos os atributos
                converted_methods.append(Method(**m))
            elif isinstance(m, Method):
                # Se já for um objeto Method, manter como está
                converted_methods.append(m)

        # Substituir a lista original pela lista convertida
        self.methods = converted_methods