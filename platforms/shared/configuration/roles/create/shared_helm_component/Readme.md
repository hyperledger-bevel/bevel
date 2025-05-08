[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## helm_component
helm_component roles helps in generating value file for various helm releases. Helm component uses the templates folder to generate helm value files. To generate a new helm file, it uses template files stored in template folder. The task uses a variable *type* which is used to filter through the templates in template folder.
The mapping for *type* variable and its corresponding value file is provided in `vars/main.yaml`.
To add a new template, add the tpl file to template folder and add its key-value entry in `vars/main.yaml`. 
This role consists of the following tasks

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. "Ensures {{ values_dir }}/{{ name }} dir exists"
This task ensures that the value directory is present on the ansible container which is referred by `values_dir` variable which is defined at `/platforms/quorum/playbooks/roles/helm_component/vars/main.yaml`
##### Input Variables

    *name: Type of the Helm Release file 
    *values_dir: The path where the generated files are stored
    *path: The path/directory where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: Type of file i.e. directory.


#### 2. create value file for {{ *component_name* }}
This task creates the value file for the role which calls it. 
##### Input Variables
    *component_name: The name of the component for whom the value file is created.
    *name: Type of the Helm Release file 
    *values_dir: The path where the generated files are stored
    *type:The corresponding template file is chosen based on this type variable.
The mapping is stored at `/platforms/quorum/playbooks/roles/helm_component/vars/main.yaml`. If the type is not found in the mapping then it takes in the default `helm_component.tpl` template.
 

#### 3. Helm lint
This task tests the value file for syntax errors/ missing values.This is done by calling the helm_lint role and passing the value file parameter. When a new helm_component is added, changes should be made in `helm_lint` role as well
##### Input Variables
    helmtemplate_type: The corresponding template file is chosen based on this type variable.
    chart_path: The path for the charts directory.
    value_file: The final path of the value file to be created along with name.
    
**include_role**: It includes the name of intermediatory role ( `{{ playbook_dir }}/../../shared/configuration/roles/helm_lint` which is required for creating the Vault Reviewer value file.
