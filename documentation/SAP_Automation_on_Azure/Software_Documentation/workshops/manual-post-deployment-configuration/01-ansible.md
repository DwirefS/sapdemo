### <img src="../../../assets/images/UnicornSAPBlack256x256.png" width="64px"> SAP Deployment Automation Framework <!-- omit in toc -->
<br/><br/>

# Bootstrapping the Deployer <!-- omit in toc -->

<br/>

## Table of contents <!-- omit in toc -->

- [Overview](#overview)
- [Notes](#notes)
- [Procedure](#procedure)
  - [Bootstrap - Deployer](#bootstrap---deployer)

<br/>

## Overview

![Block2](assets/Block2.png)
|                  |              |
| ---------------- | ------------ |
| Duration of Task | `12 minutes` |
| Steps            | `10`         |
| Runtime          | `5 minutes`  |

---

<br/><br/>

## Notes

- For the workshop the *default* naming convention is referenced and used. For the **Deployer** there are three fields.
  - `<ENV>`-`<REGION>`-`<DEPLOYER_VNET>`-INFRASTRUCTURE

    | Field             | Legnth   | Value  |
    | ----------------- | -------- | ------ |
    | `<ENV>`           | [5 CHAR] | NP     |
    | `<REGION>`        | [4 CHAR] | EUS2   |
    | `<DEPLOYER_VNET>` | [7 CHAR] | DEP00  |
  
    Which becomes this: **DEMO-EUS2-DEP00-INFRASTRUCTURE**
    
    This is used in several places:
    - The path of the Workspace Directory.
    - Input JSON file name
    - Resource Group Name.

    You will also see elements cascade into other places.

<br/><br/>

## Procedure

### Bootstrap - Deployer

<br/>







<br/><br/>


1. From the SAP Deployment Workspace directory, change to the `ansible_config_files` directory.
    ```bash
    cd ~/Azure_SAP_Automated_Deployment/WORKSPACES/SYSTEM/DEMO-EUS2-SAP00-X00/ansible_config_files
    ```
    <br/><br/>


2. Update the `sap_parameters.yaml` parameter file.
    <br/>
    
    Values to be updated:

    | Parameter                  | Value                                  |
    | -------------------------- | -------------------------------------- |
    | bom_base_name              | S419009SPS03_v1                        |
    | sapbits_location_base_path | https://<storage_account_FQDN>/sapbits |
    | password_master            | MasterPass00                           |
    | sap_fqdn                   | sap.contoso.com                        |
    
    <br/>

    ```bash
    vi sap_parameters.yaml
    ```

    ```bash
    ---

    bom_base_name:                 S41909SPS03_v1
    sapbits_location_base_path:    https://<storage_account_FQDN>/sapbits
    password_master:               MasterPass00
    sap_fqdn:                      sap.contoso.com


    # TERRAFORM CREATED
    sap_sid:                       X00
    kv_uri:                        DEMOEUS2SAP00user298
    secret_prefix:                 DEMO-EUS2-SAP00
    scs_high_availability:         false
    db_high_availability:          false

    disks:
      - { host: 'x00dhdb00l0c75', LUN: 0,  type: 'sap'    }
      - { host: 'x00dhdb00l0c75', LUN: 10, type: 'data'   }
      - { host: 'x00dhdb00l0c75', LUN: 11, type: 'data'   }
      - { host: 'x00dhdb00l0c75', LUN: 12, type: 'data'   }
      - { host: 'x00dhdb00l0c75', LUN: 13, type: 'data'   }
      - { host: 'x00dhdb00l0c75', LUN: 20, type: 'log'    }
      - { host: 'x00dhdb00l0c75', LUN: 21, type: 'log'    }
      - { host: 'x00dhdb00l0c75', LUN: 22, type: 'log'    }
      - { host: 'x00dhdb00l0c75', LUN: 2,  type: 'backup' }
      - { host: 'x00app00lc75',   LUN: 0,  type: 'sap'    }
      - { host: 'x00app01lc75',   LUN: 0,  type: 'sap'    }
      - { host: 'x00app02lc75',   LUN: 0,  type: 'sap'    }
      - { host: 'x00scs00lc75',   LUN: 0,  type: 'sap'    }
      - { host: 'x00web00lc75',   LUN: 0,  type: 'sap'    }

    ...
    ```
    <br/>


3. Execute the Ansible Playbook. <br/>There are three ways to do this.


   1. Via the Test Menu.
        ```bash
        time ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/test_menu.sh
        ```
        Note: Use  of the `time` command is optional. It is simply there to output the length of time of the execution.<br/>
              Ex: `real    1m7.984s`
        <br/><br/>
        Select the Menu option sequentially, in order, 1 - 7 or 13 for all.<br/>
        Options 8 - 12 are not yet functional. 
        ```bash
        1) Base OS Config            8) APP Install
        2) SAP specific OS Config    9) WebDisp Install
        3) BOM Processing           10) Pacemaker Setup
        4) HANA DB Install          11) Pacemaker SCS Setup
        5) SCS Install              12) Pacemaker HANA Setup
        6) DB Load                  13) Install SAP (1-7)
        7) PAS Install              14) Quit
        Please select playbook: 
        ```
        <br/><br/>


    2. Execute the Ansible playbooks individulally via `ansible-playbook` command.
        <br/>
        ```bash
        ansible-playbook                                                                                   \
          --inventory   X00_hosts.yaml                                                                     \
          --user        azureadm                                                                           \
          --private-key sshkey                                                                             \
          --extra-vars="@sap-parameters.yaml"                                                              \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/<playbook>
        ```
        Use the following playbooks in the command, as shown in the order below.
        - `playbook_01_os_base_config.yaml`
        - `playbook_02_os_sap_specific_config.yaml`
        - `playbook_03_bom_processing.yaml`
        - `playbook_04_00_00_hana_db_install.yaml`
        - `playbook_05_00_00_sap_scs_install.yaml`
        - `playbook_05_01_sap_dbload.yaml`
        - `playbook_05_02_sap_pas_install.yaml`
        <br/><br/>


    3. Execute the Ansible playbooks sequentially via a single `ansible-playbook` command.
        ```bash
        ansible-playbook                                                                                   \
          --inventory   X00_hosts.yaml                                                                     \
          --user        azureadm                                                                           \
          --private-key sshkey                                                                             \
          --extra-vars="@sap-parameters.yaml"                                                              \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_01_os_base_config.yaml         \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_02_os_sap_specific_config.yaml \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_03_bom_processing.yaml         \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_04_00_00_hana_db_install.yaml  \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_05_00_00_sap_scs_install.yaml  \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_05_01_sap_dbload.yaml          \
          ~/Azure_SAP_Automated_Deployment/sap-hana/deploy/ansible/playbook_05_02_sap_pas_install.yaml
        ```

       <br/><br/><br/><br/>


# Next: [Bootstrap - SPN](02-spn.md) <!-- omit in toc -->