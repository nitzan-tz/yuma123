/*
 * Copyright (c) 2009, Netconf Central, Inc.
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.    
 */
#ifndef _H_c
#define _H_c

/*  FILE: c.h
*********************************************************************
*								    *
*			 P U R P O S E				    *
*								    *
*********************************************************************

  Convert YANG module to C file format 
 
*********************************************************************
*								    *
*		   C H A N G E	 H I S T O R Y			    *
*								    *
*********************************************************************

date	     init     comment
----------------------------------------------------------------------
27-oct-09    abb      Begun

*/

#ifndef _H_ses
#include "ses.h"
#endif

#ifndef _H_status
#include "status.h"
#endif

#ifndef _H_yang
#include "yang.h"
#endif

#ifndef _H_yangdump
#include "yangdump.h"
#endif

/********************************************************************
*								    *
*			 C O N S T A N T S			    *
*								    *
*********************************************************************/


/********************************************************************
*								    *
*			     T Y P E S				    *
*								    *
*********************************************************************/


/********************************************************************
*								    *
*			F U N C T I O N S			    *
*								    *
*********************************************************************/


/********************************************************************
* FUNCTION c_convert_module
* 
* Generate the SIL C code for the specified module(s)
*
* INPUTS:
*   pcb == parser control block of module to convert
*          This is returned from ncxmod_load_module_ex
*   cp == conversion parms to use
*   scb == session control block for writing output
*
* RETURNS:
*   status
*********************************************************************/
extern status_t 
    c_convert_module (yang_pcb_t *pcb,
		      const yangdump_cvtparms_t *cp,
		      ses_cb_t *scb);

#endif	    /* _H_c */
